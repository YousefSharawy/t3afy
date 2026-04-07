import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class TasksHeaderStats extends StatelessWidget {
  final TasksStatsEntity stats;

  const TasksHeaderStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatBox('${stats.todayCount}', 'اليوم'),
        SizedBox(width: 8.w),
        _buildStatBox('${stats.completedCount}', 'مكتملة'),
        SizedBox(width: 8.w),
        _buildStatBox('${stats.earnedPoints}', 'النقاط المكتسبة'),
      ],
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.s16),
          color: ColorManager.white,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: getExtraBoldStyle(
                fontSize: FontSize.s20,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.primary700,
              ),
            ),
            SizedBox(height: AppHeight.s4),
            Text(
              label,
              style: getRegularStyle(
                fontSize: FontSize.s12,
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
