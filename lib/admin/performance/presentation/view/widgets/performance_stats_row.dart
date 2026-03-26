import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/perf_stat_box.dart';

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
              child: PerfStatBox(
                iconAsset: IconAssets.group,
                value: '${data.totalVolunteers}',
                label: 'متطوع',
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                ),
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: PerfStatBox(
                iconAsset: IconAssets.hours,
                value: '${data.totalHours}',
                label: 'ساعة',
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                ),
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: PerfStatBox(
                iconAsset: IconAssets.star,
                value: data.avgRating.toStringAsFixed(1),
                label: 'متوسط التقييم',
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          children: [
            Expanded(
              child: PerfStatBox(
                iconAsset: IconAssets.done2,
                value: '${data.verifiedAttendanceRate.toStringAsFixed(0)}%',
                label: 'معدل الحضور المؤكد',
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
