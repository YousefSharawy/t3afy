import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'description_section.dart';
import 'location_section.dart';
import 'notes_card.dart';
import 'objectives_section.dart';
import 'report_button.dart';
import 'supervisor_section.dart';

class TaskDetailsTab extends StatelessWidget {
  const TaskDetailsTab({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_hasLocation) ...[
          LocationSection(task: task),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.description?.isNotEmpty == true) ...[
          DescriptionSection(description: task.description!),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.objectives.isNotEmpty) ...[
          ObjectivesSection(objectives: task.objectives),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.supervisorName != null) ...[
          SupervisorSection(
            name: task.supervisorName!,
            phone: task.supervisorPhone,
          ),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.notes?.isNotEmpty == true) ...[
          NotesCard(notes: task.notes!),
          SizedBox(height: AppHeight.s16),
        ],
        ReportButton(taskId: task.id, taskTitle: task.title),
        SizedBox(height: AppHeight.s24),
      ],
    );
  }

  bool get _hasLocation =>
      task.locationName != null ||
      (task.locationLat != null && task.locationLng != null);
}
