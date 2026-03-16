import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteers_usecase.dart';

part 'volunteers_state.dart';
part 'volunteers_cubit.freezed.dart';

class VolunteersCubit extends Cubit<VolunteersState> {
  VolunteersCubit(this._getVolunteersUsecase, this._repo)
      : super(const VolunteersState.initial()) {
    loadVolunteers();
    _repo.subscribeRealtime(loadVolunteers);
    _stalenessTimer = Timer.periodic(const Duration(minutes: 1), (_) => _refreshIfLoaded());
  }

  final GetVolunteersUsecase _getVolunteersUsecase;
  final VolunteersRepo _repo;
  List<AdminVolunteerEntity> _allVolunteers = [];
  Timer? _stalenessTimer;

  Future<void> loadVolunteers() async {
    emit(const VolunteersState.loading());
    final result = await _getVolunteersUsecase();
    result.fold(
      (f) => emit(VolunteersState.error(f.message)),
      (list) {
        _allVolunteers = list;
        emit(VolunteersState.loaded(list));
      },
    );
  }

  void setFilter(String filter) {
    state.maybeWhen(
      loaded: (_, currentFilter, searchQuery) => emit(
        VolunteersState.loaded(
          _allVolunteers,
          filter: filter,
          searchQuery: searchQuery,
        ),
      ),
      orElse: () {},
    );
  }

  void setSearchQuery(String query) {
    state.maybeWhen(
      loaded: (_, filter, __) => emit(
        VolunteersState.loaded(
          _allVolunteers,
          filter: filter,
          searchQuery: query,
        ),
      ),
      orElse: () {},
    );
  }

  void _refreshIfLoaded() {
    state.maybeWhen(
      loaded: (_, filter, searchQuery) => emit(
        VolunteersState.loaded(
          _allVolunteers,
          filter: filter,
          searchQuery: searchQuery,
        ),
      ),
      orElse: () {},
    );
  }

  @override
  Future<void> close() {
    _stalenessTimer?.cancel();
    _repo.disposeRealtime();
    return super.close();
  }
}
