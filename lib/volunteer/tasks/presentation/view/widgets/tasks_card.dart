import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = task.assignmentStatus != 'completed';
    final badgeColor = task.assignmentStatus == 'completed'
        ? const Color(0xFF4CAF50) // green for مكتملة
        : task.status == 'active'
        ? const Color(0xFF2DD4BF) // teal for جارية
        : const Color(0xFFFBBF24); // amber for قادمة
    final borderColor = isActive
        ? const Color(0xFF2DD4BF).withOpacity(0.5)
        : const Color(0xFFFBBF24).withOpacity(0.5);

    final badgeText = task.assignmentStatus == 'completed'
        ? 'مكتملة'
        : task.status == 'active'
        ? 'جارية'
        : 'قادمة';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0C203B), Color(0xFF143764)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      task.type,
                      style: getRegularStyle(
                        fontSize: FontSize.s13,
                        fontFamily: FontConstants.fontFamily,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text('🏠', style: TextStyle(fontSize: 18.sp)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: badgeColor),
                  ),
                  child: Text(
                    badgeText,
                    style: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      fontFamily: FontConstants.fontFamily,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Title
            Text(
              task.title,
              textAlign: TextAlign.right,
              style: getBoldStyle(
                fontSize: FontSize.s16,
                fontFamily: FontConstants.fontFamily,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppHeight.s10),
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
                    color: ColorManager.blueOne300,
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
                    fontSize: FontSize.s11,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blueOne300,
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
                    fontSize: FontSize.s11,
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blueOne300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildChip(
                  '+${task.points}',
                  null,
                  const Color(0xFFFFCD0F),
                  trailing: Text('🏆', style: TextStyle(fontSize: 14.sp)),
                ),
                SizedBox(width: 10.w),
                _buildChip(
                  '${task.durationHours.toStringAsFixed(0)}h',
                  Icons.access_time,
                  ColorManager.blueTwo300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    String text,
    IconData? icon,
    Color color, {
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[trailing, SizedBox(width: 4.w)],
          Text(
            text,
            style: getSemiBoldStyle(
              fontSize: FontSize.s12,
              fontFamily: FontConstants.fontFamily,
              color: color,
            ),
          ),
          if (icon != null) ...[
            SizedBox(width: 4.w),
            Icon(icon, color: color, size: 14.sp),
          ],
        ],
      ),
    );
  }
}
