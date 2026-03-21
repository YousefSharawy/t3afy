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
    return Row(
      children: [
        Expanded(
          child: PerfStatBox(
            iconAsset: IconAssets.group,
            value: '${data.totalVolunteers}',
            label: 'متطوع',
            decoration: BoxDecoration(
              color: ColorManager.blueOne900,
              borderRadius: BorderRadius.circular(AppRadius.s12),
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
              color: ColorManager.blueOne900,
              borderRadius: BorderRadius.circular(AppRadius.s12),
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
              color: ColorManager.blueOne900,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
          ),
        ),
      ],
    );
  }
}
