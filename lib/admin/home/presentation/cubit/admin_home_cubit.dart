import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/admin/home/data/services/analytics_pdf_service.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/admin/home/domain/repos/admin_home_repo.dart';
import 'package:t3afy/admin/home/domain/usecases/get_admin_home_data_usecase.dart';
import 'package:t3afy/admin/home/domain/usecases/send_announcement_usecase.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'admin_home_state.dart';
part 'admin_home_cubit.freezed.dart';

/// Manager dashboard.
///
/// Data lives in [data] (survives action states such as exporting), so the
/// view keeps the dashboard on screen during exports, announcements and
/// background refreshes.
///
/// Auto-refresh every 60 s runs only while the dashboard is actually seen:
/// the app is in the foreground ([AppLifecycleListener]) and the view reports
/// itself visible via [setVisible] (driven by `TickerMode`, which
/// StatefulShellRoute.indexedStack turns off for inactive branches and the
/// Navigator turns off for routes covered by a pushed screen).
class AdminHomeCubit extends Cubit<AdminHomeState>
    with SafeEmit<AdminHomeState> {
  AdminHomeCubit(
    this._getAdminHomeDataUsecase,
    this._sendAnnouncementUsecase,
    this._repo,
  ) : super(const AdminHomeState.initial()) {
    _lifecycle = AppLifecycleListener(
      onStateChange: (s) {
        _appActive = s == AppLifecycleState.resumed;
        _syncTimer();
        _catchUpIfStale();
      },
    );
    loadDashboard();
    _syncTimer();
    // Check-ins, new assignments, report submissions and rating/level changes
    // all move dashboard numbers. Aggregate screen: coalesce bursts, but land
    // within ~1 s. (The 60 s timer stays as a safety net.)
    for (final table in const [
      'tasks',
      'task_assignments',
      'task_reports',
      'users',
    ]) {
      _hub.watch(
        name: 'admin_home_$table',
        table: table,
        onChange: _onRealtimeChange,
      );
    }
  }

  final RealtimeHub _hub = RealtimeHub(
    debounce: const Duration(milliseconds: 600),
    maxWait: const Duration(milliseconds: 1200),
    fallbackPoll: const Duration(seconds: 60),
  );

  /// A change arrived while the dashboard was not on screen: refresh once
  /// when it becomes visible again instead of refetching in the background.
  bool _staleWhileHidden = false;

  /// A refresh was requested while one was in flight: run once more after.
  bool _reloadQueued = false;

  void _onRealtimeChange() {
    if (!_visible || !_appActive) {
      _staleWhileHidden = true;
      return;
    }
    // The load in flight may predate this event: run once more after it.
    if (_loading) {
      _reloadQueued = true;
      return;
    }
    _load();
  }

  static const _refreshEvery = Duration(seconds: 60);

  final GetAdminHomeDataUsecase _getAdminHomeDataUsecase;
  final SendAnnouncementUsecase _sendAnnouncementUsecase;
  final AdminHomeRepo _repo;
  late final AppLifecycleListener _lifecycle;
  Timer? _refreshTimer;
  bool _visible = true;
  bool _appActive = true;
  bool _loading = false;

  /// True while an export / announcement is in flight: background refreshes
  /// still update [data] but don't emit `loaded` over the action state.
  bool _actionInFlight = false;

  AdminHomeDataEntity? _data;
  DateTime? _lastUpdated;

  AdminHomeDataEntity? get data => _data;
  DateTime? get lastUpdated => _lastUpdated;

  void setVisible(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    _syncTimer();
    _catchUpIfStale();
  }

  void _catchUpIfStale() {
    if (_staleWhileHidden && _visible && _appActive) {
      _staleWhileHidden = false;
      _load();
    }
  }

  void _syncTimer() {
    if (isClosed) return;
    final shouldRun = _visible && _appActive;
    if (!shouldRun) {
      _refreshTimer?.cancel();
      _refreshTimer = null;
      return;
    }
    if (_refreshTimer != null) return;
    _refreshTimer = Timer.periodic(_refreshEvery, (_) => _load());
    // Coming back after a while: catch up now instead of waiting a full tick.
    final last = _lastUpdated;
    if (last != null && DateTime.now().difference(last) >= _refreshEvery) {
      _load();
    }
  }

  /// First load and retry. Only shows the loading state when nothing is on
  /// screen yet.
  Future<void> loadDashboard() async {
    await _load();
  }

  /// Pull-to-refresh. Returns an error message when the refresh failed while
  /// the old data stays on screen (the view shows it as a toast).
  Future<String?> refresh() => _load();

  Future<String?> _load() async {
    if (_loading) return null;
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) {
      if (_data == null) safeEmit(const AdminHomeState.error('غير مصرح'));
      return 'غير مصرح';
    }
    _loading = true;
    if (_data == null) safeEmit(const AdminHomeState.loading());
    final result = await _getAdminHomeDataUsecase(adminId);
    _loading = false;
    if (_reloadQueued && !isClosed) {
      _reloadQueued = false;
      scheduleMicrotask(_load);
    }
    return result.fold(
      (f) {
        if (_data == null) safeEmit(AdminHomeState.error(f.message));
        return f.message;
      },
      (data) {
        _data = data;
        _lastUpdated = DateTime.now();
        if (!_actionInFlight) safeEmit(AdminHomeState.loaded(data));
        return null;
      },
    );
  }

  void _restoreLoaded() {
    final d = _data;
    if (d != null) safeEmit(AdminHomeState.loaded(d));
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    _lifecycle.dispose();
    _hub.dispose();
    _repo.disposeRealtime();
    return super.close();
  }

  Future<void> exportFullAnalyticsPdf() async {
    if (_actionInFlight) return;
    _actionInFlight = true;
    emit(const AdminHomeState.exportingPdf());
    try {
      await AnalyticsPdfService.exportAndShare();
      safeEmit(const AdminHomeState.exportSuccess());
    } on AnalyticsExportException catch (e) {
      safeEmit(AdminHomeState.exportError(e.message));
    } catch (e, st) {
      if (kDebugMode) debugPrint('PDF Export General Error: $e\n$st');
      safeEmit(
        const AdminHomeState.exportError('فشل إنشاء التقرير، حاول مرة أخرى'),
      );
    } finally {
      _actionInFlight = false;
      _restoreLoaded();
    }
  }

  Future<void> sendAnnouncement({
    required String title,
    required String body,
  }) async {
    if (_actionInFlight) return;
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) {
      emit(const AdminHomeState.announcementError('غير مصرح'));
      return;
    }

    _actionInFlight = true;
    emit(const AdminHomeState.announcementSending());

    final result = await _sendAnnouncementUsecase(
      title: title,
      body: body,
      adminId: adminId,
    );

    _actionInFlight = false;
    result.fold(
      (f) => safeEmit(AdminHomeState.announcementError(f.message)),
      (_) => safeEmit(const AdminHomeState.announcementSent()),
    );
    _restoreLoaded();
  }
}
