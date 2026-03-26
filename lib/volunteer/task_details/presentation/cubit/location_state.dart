part of 'location_cubit.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationFarFromTask extends LocationState {
  final double distance;
  final double currentLat;
  final double currentLng;
  LocationFarFromTask(this.distance, this.currentLat, this.currentLng);
}

class LocationNearTask extends LocationState {
  final double distance;
  final double currentLat;
  final double currentLng;
  LocationNearTask(this.distance, this.currentLat, this.currentLng);
}

class LocationCheckedIn extends LocationState {
  final DateTime checkedInAt;
  final double currentLat;
  final double currentLng;
  LocationCheckedIn(this.checkedInAt, this.currentLat, this.currentLng);
}

class LocationCheckedOut extends LocationState {
  final DateTime checkedInAt;
  final DateTime checkedOutAt;
  final double verifiedHours;
  LocationCheckedOut(this.checkedInAt, this.checkedOutAt, this.verifiedHours);
}

class LocationPermissionDenied extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
