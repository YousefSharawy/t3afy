import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
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
        if (task.assignmentStatus != 'missed')
          ReportButton(taskId: task.id, taskTitle: task.title)
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s16,
              vertical: AppHeight.s12,
            ),
            decoration: BoxDecoration(
              color: ColorManager.errorLight,
              borderRadius: BorderRadius.circular(AppRadius.s12),
              border: Border.all(color: ColorManager.error, width: 0.5),
            ),
            child: Text(
              'انتهت مدة هذه المهمة',
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.error,
              ),
            ),
          ),
        SizedBox(height: AppHeight.s24),
      ],
    );
  }

  bool get _hasLocation =>
      task.locationName != null ||
      (task.locationLat != null && task.locationLng != null);
}
