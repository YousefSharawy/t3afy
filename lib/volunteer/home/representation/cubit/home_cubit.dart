import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';
import 'package:t3afy/volunteer/home/domain/use_case/home_use_case.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmit<HomeState> {
  HomeCubit(this._getVolunteerStats, this._getTodayTasks)
    : super(const HomeState.initial());

  /// Error message the view treats as "account suspended → log out".
  static const suspendedError = '__suspended__';

  final GetVolunteerStats _getVolunteerStats;
  final GetHomeTodayTasks _getTodayTasks;
  final RealtimeHub _hub = RealtimeHub();
  String? _userId;
  bool _subscribed = false;

  bool get _hasData =>
      state.maybeWhen(loaded: (_, _, _) => true, orElse: () => false);

  void subscribeToUserUpdates(String userId) {
    if (_subscribed) return;
    _subscribed = true;
    _userId = userId;
    // The hub drops the 60 s presence heartbeat on `users`; a real change
    // (points, level, role) refetches the users row, which carries `role`,
    // so suspension is detected without an extra query per event.
    _hub.watch(
      name: 'home_user_$userId',
      table: 'users',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: userId,
      ),
      onChange: _backgroundRefresh,
    );
    _hub.watch(
      name: 'home_assignments_$userId',
      table: 'task_assignments',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      onChange: _backgroundRefresh,
    );
    // Unassign: DELETE events can't be filtered server-side.
    _hub.watch(
      name: 'home_assignments_del_$userId',
      table: 'task_assignments',
      event: PostgresChangeEvent.delete,
      ignore: (p) => deletedRowNotFor(p, 'user_id', userId),
      onChange: _backgroundRefresh,
    );
  }

  /// Normal load (tab open). Uses the cache; only the very first load shows
  /// the skeleton — with data on screen it refreshes in place.
  Future<void> loadHome(String userId) async {
    _userId = userId;
    final silent = _hasData;
    if (!silent) emit(const HomeState.loading());
    await _fetch(userId, skipCache: false, silent: silent);
  }

  /// Pull-to-refresh / return from task details: bypasses the cache and keeps
  /// the current data on failure. Returns false when the refetch failed.
  Future<bool> refresh() async {
    final userId = _userId ?? LocalAppStorage.getUserId();
    if (userId == null) return false;
    _userId = userId;
    return _fetch(userId, skipCache: true, silent: _hasData);
  }

  /// Realtime-driven: never replaces the screen with an error.
  void _backgroundRefresh() {
    final userId = _userId;
    if (userId != null) _fetch(userId, skipCache: true, silent: true);
  }

  Future<bool> _fetch(
    String userId, {
    required bool skipCache,
    required bool silent,
  }) async {
    final (statsResult, tasksResult) = await (
      _getVolunteerStats(userId, skipCache: skipCache),
      _getTodayTasks(userId, skipCache: skipCache),
    ).wait;

    final stats = statsResult.fold((_) => null, (s) => s);
    final tasks = tasksResult.fold((_) => null, (t) => t);
    if (stats == null || tasks == null) {
      if (!silent) {
        final message = statsResult.fold(
          (f) => f.message,
          (_) => tasksResult.fold((f) => f.message, (_) => ''),
        );
        safeEmit(HomeState.error(message));
      }
      return false;
    }
    if (stats.role == 'suspended') {
      safeEmit(const HomeState.error(suspendedError));
      return false;
    }
    safeEmit(HomeState.loaded(stats: stats, todayTasks: tasks, unreadCount: 0));
    return true;
  }

  @override
  Future<void> close() async {
    await _hub.dispose();
    return super.close();
  }
}
