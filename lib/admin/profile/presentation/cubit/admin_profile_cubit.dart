import 'package:bloc/bloc.dart';
import 'package:t3afy/admin/profile/domain/usecases/get_admin_profile_usecase.dart';
import 'package:t3afy/admin/profile/domain/usecases/update_admin_profile_usecase.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_state.dart';

export 'admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  AdminProfileCubit(this._getProfile, this._updateProfile)
    : super(AdminProfileInitial());

  final GetAdminProfileUsecase _getProfile;
  final UpdateAdminProfileUsecase _updateProfile;

  Future<void> loadProfile(String userId) async {
    emit(AdminProfileLoading());
    final result = await _getProfile(userId);
    result.fold(
      (f) => emit(AdminProfileError(f.message)),
      (profile) => emit(AdminProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  }) async {
    final result = await _updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      email: email,
    );
    result.fold(
      (f) => emit(AdminProfileUpdateError(f.message)),
      (_) => emit(AdminProfileUpdateSuccess()),
    );
  }
}
