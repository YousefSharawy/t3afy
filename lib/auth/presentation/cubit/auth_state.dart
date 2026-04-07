part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.success(UserEntity user) = _Success;
  const factory AuthState.registrationPending() = _RegistrationPending;
  const factory AuthState.error(String message) = _Error;
  const factory AuthState.roleChanged(bool isVolunteer) = _RoleChanged;
  const factory AuthState.genderChanged(String gender) = _GenderChanged;
}
