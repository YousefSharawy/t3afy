import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';

abstract class AdminProfileState {}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileEntity profile;
  AdminProfileLoaded(this.profile);
}

class AdminProfileError extends AdminProfileState {
  final String message;
  AdminProfileError(this.message);
}

class AdminProfileUpdateSuccess extends AdminProfileState {}

class AdminProfileUpdateError extends AdminProfileState {
  final String message;
  AdminProfileUpdateError(this.message);
}
