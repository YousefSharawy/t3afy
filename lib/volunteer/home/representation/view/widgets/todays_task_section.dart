import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/today_task_card.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({
    super.key,
    required this.tasks,
    this.onViewAll,
    this.onTaskTap,
  });

  final List<TaskEntity> tasks;
  final VoidCallback? onViewAll;
  final Function(TaskEntity task)? onTaskTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'مهام اليوم',
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blueOne900,
                fontSize: FontSize.s16,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'عرض الكل',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueThree900,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s12),
        if (tasks.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppHeight.s20),
            child: Text(
              'لا توجد مهام اليوم',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blueTwo200,
                fontSize: FontSize.s14,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == tasks.length - 1 ? 0 : AppHeight.s8,
                ),
                child: TodayTaskCard(
                  task: tasks[index],
                  onTap: () => onTaskTap?.call(tasks[index]),
                ),
              );
            },
          ),
      ],
    );
  }
}
