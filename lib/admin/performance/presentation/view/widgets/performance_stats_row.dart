import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'admin_stat_box.dart';

class PerformanceStatsRow extends StatelessWidget {
  const PerformanceStatsRow({super.key, required this.data});

  final AdminPerformanceEntity data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminStatBox(
            icon: IconAssets.group,
            value: '${data.totalVolunteers}',
            label: 'متطوع',
          ),
        ),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: AdminStatBox(
            icon: IconAssets.hours,
            value: '${data.totalHours}',
            label: 'ساعة',
          ),
        ),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: AdminStatBox(
            icon: IconAssets.star,
            value: data.avgRating.toStringAsFixed(1),
            label: 'متوسط التقييم',
            valueColor: ColorManager.amber400,
          ),
        ),
      ],
    );
  }
}
