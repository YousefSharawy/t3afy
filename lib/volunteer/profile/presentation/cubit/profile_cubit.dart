import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/domain/use_cases/profile_use_case.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile) : super(const ProfileState.initial());

  final GetProfile _getProfile;

  RealtimeChannel? _usersChannel;
  Timer? _debounce;
  String? _currentUserId;

  void _subscribeToRealtime(String userId) {
    _usersChannel?.unsubscribe();
    _usersChannel = Supabase.instance.client
        .channel('volunteer_profile_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();
  }

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (_currentUserId != null) {
        await LocalAppStorage.invalidateCache('vol_profile_$_currentUserId');
        await loadProfile(_currentUserId!);
      }
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    if (_usersChannel != null) {
      Supabase.instance.client.removeChannel(_usersChannel!);
    }
    return super.close();
  }

  Future<void> loadProfile(String userId) async {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      _subscribeToRealtime(userId);
    }
    emit(const ProfileState.loading());
    final result = await _getProfile(userId);
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }
}
