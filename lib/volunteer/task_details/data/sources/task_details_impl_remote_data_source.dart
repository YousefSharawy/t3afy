import 'package:supabase_flutter/supabase_flutter.dart';
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
  Future<TaskDetailsModel> getTaskDetails(String taskId) async {
    try {
      final currentUserId = LocalAppStorage.getUserId() ?? '';
      final response = await _client
          .from('tasks')
          .select('*, task_assignments!inner(status, user_id)')
          .eq('id', taskId)
          .eq('task_assignments.user_id', currentUserId)
          .single();

      final assignments = response['task_assignments'] as List?;
      final rawStatus = (assignments != null && assignments.isNotEmpty)
          ? assignments[0]['status'] as String?
          : null;

      final assignmentStatus = rawStatus != null
          ? resolveAssignmentStatus(
              rawStatus,
              response['date'] as String?,
              response['time_end'] as String?,
            )
          : null;

      final map = Map<String, dynamic>.from(response);
      map['assignment_status'] = assignmentStatus;
      map.remove('task_assignments');

      return TaskDetailsModel.fromJson(map);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<List<TaskObjectiveModel>> getTaskObjectives(String taskId) async {
    try {
      final response = await _client
          .from('task_objectives')
          .select()
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
          .select()
          .eq('task_id', taskId);
      return (response as List)
          .map((e) => TaskSupplyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  RealtimeChannel subscribeToTask(
    String taskId,
    void Function(Map<String, dynamic>) onUpdate,
  ) {
    return _client
        .channel('task-updates-$taskId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'tasks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: taskId,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .subscribe();
  }

  @override
  RealtimeChannel subscribeToAssignment(
    String taskId,
    void Function(Map<String, dynamic>) onUpdate,
  ) {
    final userId = LocalAppStorage.getUserId();
    return _client
        .channel('assignment-updates-$taskId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'task_assignments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'task_id',
            value: taskId,
          ),
          callback: (payload) {
            if (payload.newRecord['user_id'] == userId) {
              onUpdate(payload.newRecord);
            }
          },
        )
        .subscribe();
  }

  @override
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }
}
