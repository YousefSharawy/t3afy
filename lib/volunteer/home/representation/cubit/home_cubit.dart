import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/volunteer/home/domain/use_case/home_use_case.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getVolunteerStats, this._getTodayTasks)
      : super(const HomeState.initial());

  final GetVolunteerStats _getVolunteerStats;
  final GetTodayTasks _getTodayTasks;

  Future<void> loadHome(String userId) async {
    emit(const HomeState.loading());

    final statsResult = await _getVolunteerStats(userId);
    final tasksResult = await _getTodayTasks(userId);

    statsResult.fold(
      (failure) => emit(HomeState.error(failure.message)),
      (stats) {
        tasksResult.fold(
          (failure) => emit(HomeState.error(failure.message)),
          (tasks) => emit(HomeState.loaded(stats: stats, todayTasks: tasks)),
        );
      },
    );
  }
}