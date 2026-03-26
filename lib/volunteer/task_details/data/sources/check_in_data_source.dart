abstract class CheckInDataSource {
  /// Returns the existing check-in/out status for a task assignment.
  /// Returns null if no assignment exists.
  Future<Map<String, dynamic>?> getCheckInStatus(
      String taskId, String userId);

  /// Records check-in: sets checked_in_at, check_in_lat/lng, status='in_progress'.
  Future<void> checkIn(
      String taskId, String userId, double lat, double lng);

  /// Records check-out: sets checked_out_at, check_out_lat/lng, verified_hours, is_verified=true.
  Future<void> checkOut(
      String taskId, String userId, double lat, double lng, double verifiedHours);

  /// Inserts a periodic GPS ping into volunteer_locations.
  Future<void> recordLocation(
      String taskId, String userId, double lat, double lng);
}
