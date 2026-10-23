import 'package:bloc/bloc.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/domain/usecases/get_admin_profile_usecase.dart';
import 'package:t3afy/admin/profile/domain/usecases/update_admin_profile_usecase.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_state.dart';
import 'package:t3afy/core/data/safe_emit.dart';

export 'admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState>
    with SafeEmit<AdminProfileState> {
  AdminProfileCubit(this._getProfile, this._updateProfile)
    : super(AdminProfileInitial());

  final GetAdminProfileUsecase _getProfile;
  final UpdateAdminProfileUsecase _updateProfile;

  AdminProfileEntity? get _current {
    final s = state;
    return s is AdminProfileLoaded ? s.profile : null;
  }

  /// First load (may use the 10-min cache). Shows the skeleton only when
  /// nothing is on screen yet.
  Future<void> loadProfile(String userId) async {
    if (_current == null) emit(AdminProfileLoading());
    final result = await _getProfile(userId);
    result.fold((f) {
      if (_current == null) safeEmit(AdminProfileError(f.message));
    }, (profile) => safeEmit(AdminProfileLoaded(profile)));
  }

  /// Pull-to-refresh: always bypasses the cache and keeps the profile on
  /// screen. Returns an error message on failure (shown as a toast).
  Future<String?> refresh(String userId) async {
    final result = await _getProfile(userId, forceRefresh: true);
    return result.fold(
      (f) {
        if (_current == null) safeEmit(AdminProfileError(f.message));
        return f.message;
      },
      (profile) {
        safeEmit(AdminProfileLoaded(profile));
        return null;
      },
    );
  }

  /// Optimistic: the new values show immediately and are rolled back if the
  /// save fails. Returns an error message on failure.
  Future<String?> updateProfile({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  }) async {
    final previous = _current;
    if (previous != null) {
      emit(
        AdminProfileLoaded(
          AdminProfileEntity(
            id: previous.id,
            name: name,
            email: email,
            phone: phone,
            avatarUrl: previous.avatarUrl,
            role: previous.role,
            joinedAt: previous.joinedAt,
          ),
        ),
      );
    }
    final result = await _updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      email: email,
    );
    return result.fold((f) {
      if (previous != null) safeEmit(AdminProfileLoaded(previous));
      return f.message;
    }, (_) => null);
  }
}
