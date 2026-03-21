import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/chip_badge.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final badgeColor = task.assignmentStatus == 'completed'
        ? ColorManager.successLight
        : task.status == 'active'
        ? ColorManager.infoLight
        : ColorManager.warningLight;

    final borderColor = task.assignmentStatus == 'completed'
        ? ColorManager.success
        : task.status == 'active'
        ? ColorManager.info
        : ColorManager.warning;

    final badgeText = task.assignmentStatus == 'completed'
        ? 'مكتملة'
        : task.status == 'active'
        ? 'جارية'
        : 'قادمة';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s14),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: BorderDirectional(
            top: BorderSide(color: borderColor, width: AppWidth.s3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(IconAssets.camp),
                SizedBox(width: AppWidth.s4),
                Text(
                  task.type,
                  style: getBoldStyle(
                    fontSize: FontSize.s10,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural300,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s12,
                    vertical: AppHeight.s2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(AppRadius.s6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    badgeText,
                    style: getBoldStyle(
                      fontSize: FontSize.s10,
                      fontFamily: FontConstants.fontFamily,
                      color: borderColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppHeight.s4),
            Text(
              task.title,
              textAlign: TextAlign.right,
              style: getBoldStyle(
                fontSize: FontSize.s14,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural500,
              ),
            ),
            SizedBox(height: AppHeight.s4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  IconAssets.hours,
                  width: AppWidth.s16,
                  height: AppHeight.s16,
                ),
                SizedBox(width: AppWidth.s4),
                Text(
                  '${task.timeStart} - ${task.timeEnd}',
                  style: getRegularStyle(
                    fontSize: FontSize.s10,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural300,
                  ),
                ),
                SizedBox(width: AppWidth.s2),
                Image.asset(
                  IconAssets.location,
                  width: AppWidth.s16,
                  height: AppHeight.s16,
                ),
                SizedBox(width: AppWidth.s4),
                Text(
                  task.locationName,
                  style: getRegularStyle(
                    fontSize: FontSize.s10,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural300,
                  ),
                ),
                SizedBox(width: 2.w),
                Image.asset(
                  IconAssets.admin,
                  width: AppWidth.s16,
                  height: AppHeight.s16,
                ),
                SizedBox(width: 4.w),
                Text(
                  task.supervisorName,
                  style: getRegularStyle(
                    fontSize: FontSize.s10,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural300,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ChipBadge(
                  '+${task.points}',
                  icon: IconAssets.medal,
                  color: ColorManager.warning,
                  borderColor: ColorManager.warning,
                  fillColor:ColorManager.warningLight,
                ),
                SizedBox(width: AppWidth.s8),
                ChipBadge(
                  '${task.durationHours.toStringAsFixed(0)}h',
                  icon: IconAssets.hours,
                  color: ColorManager.primary700,
                  borderColor:ColorManager.info,
                  fillColor: ColorManager.primary50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
