import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';

abstract class VolunteerDetailsState {}

class VolunteerDetailsInitial extends VolunteerDetailsState {}

class VolunteerDetailsLoading extends VolunteerDetailsState {}

class VolunteerDetailsLoaded extends VolunteerDetailsState {
  final VolunteerDetailsEntity details;
  VolunteerDetailsLoaded(this.details);
}

class VolunteerDetailsError extends VolunteerDetailsState {
  final String message;
  VolunteerDetailsError(this.message);
}

class VolunteerDetailsDeleting extends VolunteerDetailsState {
  final VolunteerDetailsEntity details;
  VolunteerDetailsDeleting(this.details);
}

class VolunteerDetailsDeleted extends VolunteerDetailsState {}

class VolunteerDetailsActionError extends VolunteerDetailsState {
  final VolunteerDetailsEntity details;
  final String message;
  VolunteerDetailsActionError(this.details, this.message);
}

class VolunteerDetailsActionLoading extends VolunteerDetailsState {
  final VolunteerDetailsEntity details;
  VolunteerDetailsActionLoading(this.details);
}

class VolunteerDetailsActionSuccess extends VolunteerDetailsState {
  final VolunteerDetailsEntity details;
  final String message;
  VolunteerDetailsActionSuccess(this.details, this.message);
}

class VolunteerDetailsSuspended extends VolunteerDetailsState {}

class VolunteerDetailsAvailableTasks extends VolunteerDetailsState {
  final VolunteerDetailsEntity details;
  final List<Map<String, dynamic>> tasks;
  VolunteerDetailsAvailableTasks(this.details, this.tasks);
}
