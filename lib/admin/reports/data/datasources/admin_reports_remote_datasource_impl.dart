import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

class AdminReportsRemoteDatasourceImpl implements AdminReportsRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<List<AdminReportEntity>> getReports() async {
    try {
      final data = await _client
          .from('task_reports')
          .select(
            'id, task_id, user_id, summary, challenges, attendees_count, '
            'materials_distributed, additional_notes, rating, status, '
            'admin_feedback, reviewed_by, reviewed_at, created_at, '
            'tasks(title), users!task_reports_user_id_fkey(name, avatar_url)',
          )
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
        // Independent reads in parallel: the assignment row (double-credit
        // guard + GPS-verified hours) and the task's stats fields.
        final reads = await Future.wait<Map<String, dynamic>?>([
          _client
              .from('task_assignments')
              .select('status, verified_hours, is_verified')
              .eq('task_id', taskId)
              .eq('user_id', volunteerId)
              .maybeSingle(),
          _client
              .from('tasks')
              .select('duration_hours, location_name, points')
              .eq('id', taskId)
              .single(),
        ]);
        final assignmentRow = reads[0];
        final task = reads[1]!;

        // Guard: already completed → already credited.
        if ((assignmentRow?['status'] as String?) == 'completed') return;

        final isVerifiedAssignment =
            (assignmentRow?['is_verified'] as bool?) ?? false;
        final assignmentVerifiedHours =
            ((assignmentRow?['verified_hours'] as num?) ?? 0).toDouble();
        final plannedHours = ((task['duration_hours'] as num?) ?? 0).toDouble();
        final durationHours =
            (isVerifiedAssignment && assignmentVerifiedHours > 0)
            ? assignmentVerifiedHours
            : plannedHours;

        final taskPoints = (task['points'] as int?) ?? 0;
        final locationName = task['location_name'] as String?;
        final hasLocation = locationName != null && locationName.isNotEmpty;

        // Current totals + "has the volunteer completed a task here before?"
        final userAndPlace = await Future.wait<Object?>([
          _client
              .from('users')
              .select('total_tasks, total_hours, places_visited, total_points')
              .eq('id', volunteerId)
              .single(),
          if (hasLocation)
            _client
                .from('task_assignments')
                .select('id, tasks!inner(location_name)')
                .eq('user_id', volunteerId)
                .eq('status', 'completed')
                .eq('tasks.location_name', locationName)
                .limit(1),
        ]);
        final userRow = userAndPlace[0] as Map<String, dynamic>;
        final currentTasks = (userRow['total_tasks'] as int?) ?? 0;
        final currentHours = (userRow['total_hours'] as int?) ?? 0;
        final currentPlaces = (userRow['places_visited'] as int?) ?? 0;
        final currentPoints = (userRow['total_points'] as int?) ?? 0;
        final isNewPlace =
            hasLocation && (userAndPlace[1] as List).isEmpty;

        // Writes stay sequential: if crediting fails the assignment is not
        // marked completed, so a retry can still credit the volunteer.
        // Note: totals are read-modify-write (not atomic) — two managers
        // approving for the same volunteer at once can lose one increment.
        await _client
            .from('users')
            .update({
              'total_tasks': currentTasks + 1,
              'total_hours': currentHours + durationHours.round(),
              'places_visited': isNewPlace ? currentPlaces + 1 : currentPlaces,
              'total_points': currentPoints + taskPoints,
            })
            .eq('id', volunteerId);

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
            .not('status', 'in', '("completed")')
            .count(CountOption.exact);
        if (nonCompleted.count == 0) {
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
}
