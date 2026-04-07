import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/home/domain/use_case/home_use_case.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._getVolunteerStats,
    this._getTodayTasks,
    this._getUnreadNotificationsCount,
  ) : super(const HomeState.initial());

  final GetVolunteerStats _getVolunteerStats;
  final GetHomeTodayTasks _getTodayTasks;
  final GetUnreadNotificationsCount _getUnreadNotificationsCount;
  RealtimeChannel? _userChannel;
  RealtimeChannel? _assignmentsChannel;
  RealtimeChannel? _notesChannel;
  Timer? _debounce;
  bool _subscribed = false;

  void subscribeToUserUpdates(String userId) {
    if (_subscribed) return;
    _subscribed = true;
    _userChannel = Supabase.instance.client
        .channel('home_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (_) => _onRealtimeChange(userId),
        )
        .subscribe();

    _assignmentsChannel = Supabase.instance.client
        .channel('home_assignments_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_assignments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) => _onRealtimeChange(userId),
        )
        .subscribe();

    _notesChannel = Supabase.instance.client
        .channel('home_notes_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'admin_notes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'volunteer_id',
            value: userId,
          ),
          callback: (_) => _onRealtimeChange(userId),
        )
        .subscribe();
  }

  void _onRealtimeChange(String userId) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkRoleAndLoad(userId);
    });
  }

  Future<void> _checkRoleAndLoad(String userId) async {
    try {
      final row = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      if (row != null && row['role'] == 'suspended') {
        emit(const HomeState.error('__suspended__'));
        return;
      }
    } catch (_) {}
    await _silentRefresh(userId);
  }

  Future<void> _silentRefresh(String userId) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    await LocalAppStorage.invalidateCache('today_tasks_${userId}_$today');
    await LocalAppStorage.invalidateCache('vol_stats_v2_$userId');
    final statsResult = await _getVolunteerStats(userId);
    final tasksResult = await _getTodayTasks(userId);
    final unreadCount = await _fetchUnreadCount(userId);
    statsResult.fold(
      (_) {}, // silently ignore errors on background refetch
      (stats) {
        tasksResult.fold(
          (_) {},
          (tasks) => emit(
            HomeState.loaded(
              stats: stats,
              todayTasks: tasks,
              unreadCount: unreadCount,
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    final client = Supabase.instance.client;
    if (_userChannel != null) client.removeChannel(_userChannel!);
    if (_assignmentsChannel != null) client.removeChannel(_assignmentsChannel!);
    if (_notesChannel != null) client.removeChannel(_notesChannel!);
    return super.close();
  }

  Future<void> loadHome(String userId) async {
    emit(const HomeState.loading());

    final today = DateTime.now().toIso8601String().split('T').first;
    await LocalAppStorage.invalidateCache('vol_stats_v2_$userId');
    await LocalAppStorage.invalidateCache('today_tasks_${userId}_$today');

    final statsResult = await _getVolunteerStats(userId);
    final tasksResult = await _getTodayTasks(userId);
    final unreadCount = await _fetchUnreadCount(userId);

    statsResult.fold((failure) => emit(HomeState.error(failure.message)), (
      stats,
    ) {
      tasksResult.fold(
        (failure) => emit(HomeState.error(failure.message)),
        (tasks) => emit(
          HomeState.loaded(
            stats: stats,
            todayTasks: tasks,
            unreadCount: unreadCount,
          ),
        ),
      );
    });
  }

  Future<int> _fetchUnreadCount(String userId) async {
    final result = await _getUnreadNotificationsCount(userId);
    return result.fold((_) => 0, (count) => count);
  }
}
