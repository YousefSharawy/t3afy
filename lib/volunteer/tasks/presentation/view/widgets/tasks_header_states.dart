import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
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
          borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(colors: [
          ColorManager.blueOne900,
          ColorManager.blueOne800
        ])
        ),
        child: Column(
          children: [
            Text(
              value,
              style: getBoldStyle(
                fontSize: FontSize.s22,
                fontFamily: FontConstants.fontFamily,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: getRegularStyle(
                fontSize: FontSize.s12,
                fontFamily: FontConstants.fontFamily,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}