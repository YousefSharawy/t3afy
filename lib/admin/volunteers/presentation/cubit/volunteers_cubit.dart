import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/add_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_pending_users_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteers_usecase.dart';

part 'volunteers_state.dart';
part 'volunteers_cubit.freezed.dart';

class VolunteersCubit extends Cubit<VolunteersState> {
  VolunteersCubit(
    this._getVolunteersUsecase,
    this._repo,
    this._addVolunteerUsecase,
    this._getPendingUsersUsecase,
  ) : super(const VolunteersState.initial()) {
    loadVolunteers();
    _repo.subscribeRealtime(loadVolunteers);
    _stalenessTimer = Timer.periodic(const Duration(minutes: 1), (_) => _refreshIfLoaded());
  }

  final GetVolunteersUsecase _getVolunteersUsecase;
  final VolunteersRepo _repo;
  final AddVolunteerUsecase _addVolunteerUsecase;
  final GetPendingUsersUsecase _getPendingUsersUsecase;
  List<AdminVolunteerEntity> _allVolunteers = [];
  List<AdminVolunteerEntity> _pendingUsers = [];
  Timer? _stalenessTimer;

  Future<void> loadVolunteers() async {
    emit(const VolunteersState.loading());
    final result = await _getVolunteersUsecase();
    result.fold(
      (f) => emit(VolunteersState.error(f.message)),
      (list) {
        _allVolunteers = list;
        emit(VolunteersState.loaded(list, pendingUsers: _pendingUsers));
      },
    );
  }

  Future<void> loadPendingUsers() async {
    final s = state;
    if (s is! _Loaded) return;
    emit(s.copyWith(pendingLoading: true));
    final result = await _getPendingUsersUsecase();
    result.fold(
      (f) => emit(s.copyWith(pendingLoading: false)),
      (list) {
        _pendingUsers = list;
        emit(s.copyWith(pendingUsers: list, pendingLoading: false));
      },
    );
  }

  Future<void> addVolunteer({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  }) async {
    emit(const VolunteersState.loading());
    final result = await _addVolunteerUsecase(
      name: name,
      email: email,
      phone: phone,
      region: region,
      qualification: qualification,
    );
    result.fold(
      (f) => emit(VolunteersState.error(f.message)),
      (_) => loadVolunteers(),
    );
  }

  void setFilter(String filter) {
    final s = state;
    if (s is! _Loaded) return;
    emit(s.copyWith(filter: filter));
  }

  void setSearchQuery(String query) {
    final s = state;
    if (s is! _Loaded) return;
    emit(s.copyWith(searchQuery: query));
  }

  void _refreshIfLoaded() {
    final s = state;
    if (s is! _Loaded) return;
    emit(s.copyWith(volunteers: _allVolunteers));
  }

  @override
  Future<void> close() {
    _stalenessTimer?.cancel();
    _repo.disposeRealtime();
    return super.close();
  }
}
