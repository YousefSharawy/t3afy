import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/volunteer_task_card.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({
    super.key,
    required this.tasks,
    required this.onViewAll,
    required this.onTaskTap,
  });

  final List<TaskEntity> tasks;
  final VoidCallback onViewAll;
  final ValueChanged<TaskEntity> onTaskTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'مهام اليوم',
          actionLabel: tasks.isEmpty ? null : 'عرض الكل',
          onAction: onViewAll,
        ),
        if (tasks.isEmpty)
          AppEmptyState(
            compact: true,
            icon: AppIcons.tasks,
            title: 'لا توجد مهام اليوم',
            message: 'ستظهر هنا المهام المسندة إليك لهذا اليوم',
            actionLabel: 'عرض كل المهام',
            onAction: onViewAll,
          )
        else
          for (var i = 0; i < tasks.length; i++) ...[
            if (i > 0) SizedBox(height: Space.vm),
            VolunteerTaskCard(
              key: ValueKey(tasks[i].id),
              task: tasks[i],
              onTap: () => onTaskTap(tasks[i]),
            ),
          ],
      ],
    );
  }
}
