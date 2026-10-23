import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/ui_utiles.dart';

import '../models/task_details_model.dart';
import '../models/task_objective_model.dart';
import '../models/task_supply_model.dart';
import 'task_details_remote_data_source.dart';

class TaskDetailsImplRemoteDataSource implements TaskDetailsRemoteDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<TaskWithAssignment> getTaskDetails(String taskId) async {
    try {
      final currentUserId = LocalAppStorage.getUserId() ?? '';
      final response = await _client
          .from('tasks')
          .select(
            'id, title, type, description, status, date, time_start, time_end, '
            'duration_hours, points, location_name, location_address, '
            'location_lat, location_lng, supervisor_name, supervisor_phone, notes, '
            'task_assignments!inner(status, user_id, checked_in_at, checked_out_at, '
            'verified_hours, is_verified, check_in_lat, check_in_lng), '
            'users!tasks_created_by_fkey(id, name)',
          )
          .eq('id', taskId)
          .eq('task_assignments.user_id', currentUserId)
          .single();

      final assignments = response['task_assignments'] as List?;
      final assignment = (assignments != null && assignments.isNotEmpty)
          ? Map<String, dynamic>.from(assignments[0] as Map)
          : null;
      final rawStatus = assignment?['status'] as String?;

      final assignmentStatus = rawStatus != null
          ? resolveAssignmentStatus(
              rawStatus,
              response['date'] as String?,
              response['time_end'] as String?,
            )
          : null;

      final resolvedTaskStatus = resolveCampaignStatus(
        response['status'] as String? ?? 'upcoming',
        response['date'] as String?,
        response['time_end'] as String?,
      );

      final adminUser = response['users'] as Map<String, dynamic>?;
      final adminName = adminUser?['name'] as String? ?? '';

      final map = Map<String, dynamic>.from(response);
      map['assignment_status'] = assignmentStatus;
      map['status'] = resolvedTaskStatus;
      map['time_start'] = (map['time_start'] as String?) ?? '00:00';
      map['time_end'] = (map['time_end'] as String?) ?? '23:59';
      map['location_name'] = (map['location_name'] as String?) ?? '';
      map['location_address'] = (map['location_address'] as String?) ?? '';
      map['supervisor_name'] = adminName.isNotEmpty
          ? adminName
          : ((map['supervisor_name'] as String?) ?? '');
      map['supervisor_phone'] = (map['supervisor_phone'] as String?) ?? '';

      // Calculate duration from timeStart and timeEnd if not provided
      final durationHours = (map['duration_hours'] as num?)?.toDouble();
      if (durationHours == null || durationHours == 0) {
        final calculatedDuration = _calculateDuration(
          map['time_start'] as String?,
          map['time_end'] as String?,
        );
        map['duration_hours'] = calculatedDuration;
      }

      map.remove('task_assignments');
      map.remove('users');

      return (task: TaskDetailsModel.fromJson(map), assignment: assignment);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<TaskObjectiveModel>> getTaskObjectives(String taskId) async {
    try {
      final response = await _client
          .from('task_objectives')
          .select('id, task_id, title, order_index')
          .eq('task_id', taskId)
          .order('order_index', ascending: true);
      return (response as List)
          .map((e) => TaskObjectiveModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<TaskSupplyModel>> getTaskSupplies(String taskId) async {
    try {
      final response = await _client
          .from('task_supplies')
          .select('id, task_id, name, quantity')
          .eq('task_id', taskId);
      return (response as List)
          .map((e) => TaskSupplyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<CampaignPaperEntity>> getTaskPapers(String taskId) async {
    try {
      final response = await _client
          .from('task_papers')
          .select('id, file_url, file_name')
          .eq('task_id', taskId);
      return (response as List)
          .map(
            (p) => CampaignPaperEntity(
              id: p['id'] as String,
              fileUrl: p['file_url'] as String? ?? '',
              fileName: p['file_name'] as String? ?? '',
            ),
          )
          .toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  double _calculateDuration(String? timeStart, String? timeEnd) {
    if (timeStart == null || timeEnd == null) return 0;
    try {
      final startParts = timeStart.split(':');
      final endParts = timeEnd.split(':');
      if (startParts.length < 2 || endParts.length < 2) return 0;
      final startMin =
          (int.tryParse(startParts[0]) ?? 0) * 60 +
          (int.tryParse(startParts[1]) ?? 0);
      final endMin =
          (int.tryParse(endParts[0]) ?? 0) * 60 +
          (int.tryParse(endParts[1]) ?? 0);
      final diff = endMin - startMin;
      return diff > 0 ? (diff / 60.0 * 10).round() / 10.0 : 0;
    } catch (_) {
      return 0;
    }
  }
}
