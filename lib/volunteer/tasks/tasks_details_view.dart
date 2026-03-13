// volunteer/tasks/task_details_view.dart
import 'package:flutter/material.dart';

class TaskDetailsView extends StatelessWidget {
  const TaskDetailsView({super.key, required this.taskId});
  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Task Details: $taskId')),
    );
  }
}