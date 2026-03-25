import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

class AdminReportsRemoteDatasourceImpl
    implements AdminReportsRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<List<AdminReportEntity>> getReports() async {
    try {
      final data = await _client
          .from('task_reports')
          .select(
              '*, tasks(title), users!task_reports_user_id_fkey(name)')
          .order('created_at', ascending: false);
      return (data as List)
          .map((e) => AdminReportEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> reviewReport({
    required String reportId,
    required String status,
    String? feedback,
    required String adminId,
  }) async {
    try {
      // Update the report and retrieve task_id + user_id in one call
      final updated = await _client
          .from('task_reports')
          .update({
            'status': status,
            'admin_feedback': feedback,
            'reviewed_by': adminId,
            'reviewed_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', reportId)
          .select('task_id, user_id')
          .single();

      final taskId = updated['task_id'] as String;
      final volunteerId = updated['user_id'] as String;

      if (status == 'approved') {
        // Fetch task details needed for stats
        final task = await _client
            .from('tasks')
            .select('duration_hours, location_name, points')
            .eq('id', taskId)
            .single();
        final durationHours =
            ((task['duration_hours'] as num?) ?? 0).toDouble();
        final taskPoints = (task['points'] as int?) ?? 0;
        final locationName = task['location_name'] as String?;

        // Update volunteer stats
        final userRow = await _client
            .from('users')
            .select('total_tasks, total_hours, places_visited, total_points')
            .eq('id', volunteerId)
            .single();
        final currentTasks = (userRow['total_tasks'] as int?) ?? 0;
        final currentHours = (userRow['total_hours'] as int?) ?? 0;
        final currentPlaces = (userRow['places_visited'] as int?) ?? 0;
        final currentPoints = (userRow['total_points'] as int?) ?? 0;

        // Check if this is a new location for the volunteer
        int newPlaces = currentPlaces;
        if (locationName != null && locationName.isNotEmpty) {
          final locRes = await _client
              .from('task_assignments')
              .select('tasks!inner(location_name)')
              .eq('user_id', volunteerId)
              .eq('status', 'completed')
              .eq('tasks.location_name', locationName);
          if ((locRes as List).isEmpty) {
            newPlaces = currentPlaces + 1;
          }
        }

        await _client.from('users').update({
          'total_tasks': currentTasks + 1,
          'total_hours': currentHours + durationHours.round(),
          'places_visited': newPlaces,
          'total_points': currentPoints + taskPoints,
        }).eq('id', volunteerId);

        // Mark this volunteer's assignment as completed.
        await _client
            .from('task_assignments')
            .update({'status': 'completed'})
            .eq('task_id', taskId)
            .eq('user_id', volunteerId);

        // Mark task as done if ALL assignments are now completed.
        final nonCompleted = await _client
            .from('task_assignments')
            .select('id')
            .eq('task_id', taskId)
            .not('status', 'in', '("completed")');
        if ((nonCompleted as List).isEmpty) {
          await _client
              .from('tasks')
              .update({'status': 'done'})
              .eq('id', taskId);
        }
      } else if (status == 'rejected') {
        // Reset assignment so volunteer can resubmit.
        await _client
            .from('task_assignments')
            .update({'status': 'assigned'})
            .eq('task_id', taskId)
            .eq('user_id', volunteerId);

        // Send rejection notification to volunteer.
        await _client.from('admin_notes').insert({
          'admin_id': adminId,
          'volunteer_id': volunteerId,
          'task_id': taskId,
          'title': 'تم رفض التقرير',
          'body': feedback ?? 'تم رفض تقريرك من قبل المشرف',
          'is_read': false,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  RealtimeChannel subscribeRealtime(void Function() onChanged) {
    return _client
        .channel('task_reports_admin')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_reports',
          callback: (_) => onChanged(),
        )
        .subscribe();
  }
}
