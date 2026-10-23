import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/task_campaign_card.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

/// Maps a volunteer [TaskEntity] onto the shared [TaskCampaignCard]
/// (used by Home "today" and the Tasks tab).
class VolunteerTaskCard extends StatelessWidget {
  const VolunteerTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.showDate = false,
  });

  final TaskEntity task;
  final VoidCallback? onTap;

  /// History rows need the date; today's rows don't.
  final bool showDate;

  /// A finished assignment (completed / missed) outranks the task's own status.
  String get _status {
    final a = task.assignmentStatus;
    if (a == 'completed' || a == 'missed') return a;
    return task.status;
  }

  @override
  Widget build(BuildContext context) {
    final date = showDate ? DateAr.tryParse(task.date) : null;
    final minutes = (task.durationHours * 60).round();
    final supervisor = task.supervisorName.trim();

    return TaskCampaignCard(
      title: task.title,
      status: _status,
      typeLabel: task.type,
      time: DateAr.timeRange(task.timeStart, task.timeEnd),
      date: date != null ? DateAr.dayMonth(date) : null,
      location: task.locationName,
      points: task.points,
      trailing: (supervisor.isEmpty && minutes <= 0)
          ? null
          : Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (supervisor.isNotEmpty)
                    Flexible(
                      child: MetaItem(icon: AppIcons.mentor, text: supervisor),
                    ),
                  if (supervisor.isNotEmpty && minutes > 0)
                    SizedBox(width: Space.m),
                  if (minutes > 0)
                    MetaItem(
                      icon: AppIcons.hours,
                      text: DateAr.duration(Duration(minutes: minutes)),
                    ),
                ],
              ),
            ),
      onTap: onTap,
    );
  }
}
