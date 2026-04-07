import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';

import 'check_in_data_source.dart';

class CheckInImplDataSource implements CheckInDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<Map<String, dynamic>?> getCheckInStatus(
    String taskId,
    String userId,
  ) async {
    try {
      final res = await _client
          .from('task_assignments')
          .select(
            'checked_in_at, checked_out_at, verified_hours, is_verified, check_in_lat, check_in_lng',
          )
          .eq('task_id', taskId)
          .eq('user_id', userId)
          .maybeSingle();
      return res;
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> checkIn(
    String taskId,
    String userId,
    double lat,
    double lng,
  ) async {
    try {
      await _client
          .from('task_assignments')
          .update({
            'checked_in_at': DateTime.now().toUtc().toIso8601String(),
            'check_in_lat': lat,
            'check_in_lng': lng,
            'status': 'in_progress',
          })
          .eq('task_id', taskId)
          .eq('user_id', userId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> checkOut(
    String taskId,
    String userId,
    double lat,
    double lng,
    double verifiedHours,
  ) async {
    try {
      await _client
          .from('task_assignments')
          .update({
            'checked_out_at': DateTime.now().toUtc().toIso8601String(),
            'check_out_lat': lat,
            'check_out_lng': lng,
            'verified_hours': verifiedHours,
            'is_verified': true,
          })
          .eq('task_id', taskId)
          .eq('user_id', userId);
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> recordLocation(
    String taskId,
    String userId,
    double lat,
    double lng,
  ) async {
    try {
      await _client.from('volunteer_locations').insert({
        'user_id': userId,
        'task_id': taskId,
        'latitude': lat,
        'longitude': lng,
        'recorded_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      // Non-fatal — don't throw, just swallow GPS ping failures
    }
  }
}
