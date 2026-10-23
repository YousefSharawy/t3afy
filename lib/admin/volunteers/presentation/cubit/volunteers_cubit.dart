import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/add_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_pending_users_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteers_usecase.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'volunteers_state.dart';
part 'volunteers_cubit.freezed.dart';

class VolunteersCubit extends Cubit<VolunteersState>
    with SafeEmit<VolunteersState> {
  VolunteersCubit(
    this._getVolunteersUsecase,
    this._repo,
    this._addVolunteerUsecase,
    this._getPendingUsersUsecase,
  ) : super(const VolunteersState.initial()) {
    loadVolunteers();
    _hub.watch(
      name: 'admin-volunteers',
      table: 'users',
      keepPresence: true,
      onPayload: _onUserEvent,
      onChange: _realtimeRefresh,
    );
  }

  final GetVolunteersUsecase _getVolunteersUsecase;
  // Kept for the DI signature; realtime now goes through [RealtimeHub].
  // ignore: unused_field
  final VolunteersRepo _repo;
  final AddVolunteerUsecase _addVolunteerUsecase;
  final GetPendingUsersUsecase _getPendingUsersUsecase;
  List<AdminVolunteerEntity> _allVolunteers = [];
  List<AdminVolunteerEntity> _pendingUsers = [];
  final RealtimeHub _hub = RealtimeHub();

  /// First load (skeleton) or retry after an error. When a list is already on
  /// screen this is a silent refresh instead.
  Future<void> loadVolunteers() async {
    if (state is _Loaded) {
      await _fetch(forceRefresh: true);
      return;
    }
    emit(const VolunteersState.loading());
    final result = await _getVolunteersUsecase();
    result.fold(
      (f) => safeEmit(VolunteersState.error(f.message)),
      _emitList,
    );
  }

  /// Pull-to-refresh: bypasses the cache and keeps the current list. Returns
  /// an error message when the refresh failed (the view shows a toast).
  Future<String?> refresh() async {
    if (state is! _Loaded) {
      await loadVolunteers();
      return null;
    }
    return _fetch(forceRefresh: true);
  }

  Future<String?> _fetch({required bool forceRefresh}) async {
    final result = await _getVolunteersUsecase(forceRefresh: forceRefresh);
    return result.fold((f) {
      if (state is! _Loaded) safeEmit(VolunteersState.error(f.message));
      return f.message;
    }, (list) {
      _emitList(list);
      return null;
    });
  }

  /// Emits [list] while keeping the active filter, search and pending users.
  void _emitList(List<AdminVolunteerEntity> list) {
    _allVolunteers = list;
    final s = state;
    if (s is _Loaded) {
      safeEmit(s.copyWith(volunteers: list));
    } else {
      safeEmit(VolunteersState.loaded(list, pendingUsers: _pendingUsers));
    }
  }

  void _realtimeRefresh() => _fetch(forceRefresh: true);

  /// Patches the list straight from the `users` row (every column the list
  /// shows lives on it): heartbeats, rating, level, hours. Returns false when
  /// a refetch is needed (new user, role change, delete, list not loaded).
  bool _onUserEvent(PostgresChangePayload p) {
    if (state is! _Loaded) return false;
    if (p.eventType != PostgresChangeEvent.update || p.newRecord.isEmpty) {
      return false;
    }
    final AdminVolunteerEntity fresh;
    try {
      fresh = AdminVolunteerEntity.fromJson(p.newRecord);
    } catch (_) {
      return false;
    }
    final i = _allVolunteers.indexWhere((v) => v.id == fresh.id);
    if (i == -1) {
      // e.g. the manager's own heartbeat; only a role change into the
      // list's roles matters.
      return fresh.role != 'volunteer' && fresh.role != 'user';
    }
    final old = _allVolunteers[i];
    if (old.sameExceptPresence(fresh)) {
      _patchPresence(i, fresh);
      return true;
    }
    // Role change can move the row in/out of the list: refetch.
    if (old.role != fresh.role) return false;
    final next = List<AdminVolunteerEntity>.of(_allVolunteers);
    next[i] = fresh;
    _emitList(next);
    // The Hive copy of the list is now stale.
    LocalAppStorage.invalidateCache('admin_volunteers');
    return true;
  }

  /// Heartbeats update the row in memory — no refetch, no rebuild of the
  /// whole screen, and the filter/search stay as they are.
  void _patchPresence(int index, AdminVolunteerEntity fresh) {
    final old = _allVolunteers[index];
    if (old.isOnline == fresh.isOnline && old.lastSeenAt == fresh.lastSeenAt) {
      return;
    }
    final next = List<AdminVolunteerEntity>.of(_allVolunteers);
    next[index] = AdminVolunteerEntity(
      id: old.id,
      name: old.name,
      avatarUrl: old.avatarUrl,
      rating: old.rating,
      region: old.region,
      totalHours: old.totalHours,
      totalTasks: old.totalTasks,
      isOnline: fresh.isOnline,
      lastSeenAt: fresh.lastSeenAt,
      role: old.role,
      level: fresh.level ?? old.level,
    );
    _emitList(next);
  }

  Future<void> loadPendingUsers() async {
    final s = state;
    if (s is! _Loaded) return;
    emit(s.copyWith(pendingLoading: true));
    final result = await _getPendingUsersUsecase();
    final current = state;
    if (current is! _Loaded) return;
    result.fold((f) => safeEmit(current.copyWith(pendingLoading: false)), (
      list,
    ) {
      _pendingUsers = list;
      safeEmit(current.copyWith(pendingUsers: list, pendingLoading: false));
    });
  }

  /// Returns an error message on failure; the list stays on screen either way.
  Future<String?> addVolunteer({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  }) async {
    final result = await _addVolunteerUsecase(
      name: name,
      email: email,
      phone: phone,
      region: region,
      qualification: qualification,
    );
    return result.fold((f) => f.message, (_) {
      _fetch(forceRefresh: true);
      return null;
    });
  }

  void setFilter(String filter) {
    final s = state;
    if (s is! _Loaded || s.filter == filter) return;
    emit(s.copyWith(filter: filter));
  }

  void setSearchQuery(String query) {
    final s = state;
    if (s is! _Loaded || s.searchQuery == query) return;
    emit(s.copyWith(searchQuery: query));
  }

  @override
  Future<void> close() async {
    await _hub.dispose();
    return super.close();
  }
}
