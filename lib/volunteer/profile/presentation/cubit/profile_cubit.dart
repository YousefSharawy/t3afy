import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/domain/use_cases/profile_use_case.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> with SafeEmit<ProfileState> {
  ProfileCubit(this._getProfile) : super(const ProfileState.initial());

  final GetProfile _getProfile;

  RealtimeHub? _hub;
  String? _currentUserId;

  bool get _hasData =>
      state.maybeWhen(loaded: (_) => true, orElse: () => false);

  void _subscribeToRealtime(String userId) {
    _hub?.dispose();
    _hub = RealtimeHub()
      ..watch(
        name: 'volunteer_profile_user_$userId',
        table: 'users',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: userId,
        ),
        onChange: () {
          final id = _currentUserId;
          if (id != null && !isClosed) refresh(id);
        },
      );
  }

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }

  /// Bypasses the 1-minute cache and keeps the current profile on screen.
  /// Returns an error message when the refresh failed.
  Future<String?> refresh(String userId) async {
    await LocalAppStorage.invalidateCache('vol_profile_$userId');
    return loadProfile(userId);
  }

  /// Only the first load emits loading; later loads swap data in place and a
  /// failure never replaces a loaded profile. Returns the error, if any.
  Future<String?> loadProfile(String userId) async {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      _subscribeToRealtime(userId);
    }
    final hadData = _hasData;
    if (!hadData) safeEmit(const ProfileState.loading());
    final result = await _getProfile(userId);
    return result.fold(
      (failure) {
        if (!hadData) safeEmit(ProfileState.error(failure.message));
        return failure.message;
      },
      (profile) {
        safeEmit(ProfileState.loaded(profile));
        return null;
      },
    );
  }
}
