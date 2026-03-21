import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/volunteer/home/domain/use_case/home_use_case.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getVolunteerStats, this._getTodayTasks)
      : super(const HomeState.initial());

  final GetVolunteerStats _getVolunteerStats;
  final GetHomeTodayTasks _getTodayTasks;
  RealtimeChannel? _userChannel;

  void subscribeToUserUpdates(String userId) {
    _userChannel = Supabase.instance.client
        .channel('home_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (_) => loadHome(userId),
        )
        .subscribe();
  }

  @override
  Future<void> close() async {
    await _userChannel?.unsubscribe();
    return super.close();
  }

  Future<void> loadHome(String userId) async {
    emit(const HomeState.loading());

    final statsResult = await _getVolunteerStats(userId);
    final tasksResult = await _getTodayTasks(userId);
    final unreadCount = await _fetchUnreadCount(userId);

    statsResult.fold(
      (failure) => emit(HomeState.error(failure.message)),
      (stats) {
        tasksResult.fold(
          (failure) => emit(HomeState.error(failure.message)),
          (tasks) => emit(HomeState.loaded(
            stats: stats,
            todayTasks: tasks,
            unreadCount: unreadCount,
          )),
        );
      },
    );
  }

  Future<int> _fetchUnreadCount(String userId) async {
    try {
      final res = await Supabase.instance.client
          .from('admin_notes')
          .select('id')
          .eq('volunteer_id', userId)
          .eq('is_read', false);
      return res.length;
    } catch (_) {
      return 0;
    }
  }
}