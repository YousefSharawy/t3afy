import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';

class PerformanceStatsRow extends StatelessWidget {
  const PerformanceStatsRow({super.key, required this.data});

  final AdminPerformanceEntity data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: AppIcons.group,
                value: '${data.totalVolunteers}',
                label: 'متطوع جديد',
              ),
            ),
            SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                icon: AppIcons.hours,
                tint: ColorManager.info,
                value: '${data.totalHours}',
                label: 'ساعة تطوع',
              ),
            ),
          ],
        ),
        SizedBox(height: Space.vs),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: AppIcons.star,
                tint: ColorManager.starText,
                value: data.avgRating.toStringAsFixed(1),
                label: 'متوسط التقييم',
              ),
            ),
            SizedBox(width: Space.s),
            Expanded(
              child: StatTile(
                icon: AppIcons.checkIn,
                tint: ColorManager.sproutText,
                value: '${data.verifiedAttendanceRate.toStringAsFixed(0)}%',
                label: 'معدل الحضور المؤكد',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
