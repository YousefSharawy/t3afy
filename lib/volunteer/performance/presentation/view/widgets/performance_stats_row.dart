import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/base/widgets/perf_stat_box.dart';

class PerformanceStatsRow extends StatelessWidget {
  const PerformanceStatsRow({super.key, required this.stats});

  final PerformanceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PerfStatBox(
            iconAsset: IconAssets.alarm,
            value: stats.totalHours.toString(),
            label: 'الساعات',
          ),
        ),
        SizedBox(width: AppWidth.s10),
        Expanded(
          child: PerfStatBox(
            iconAsset: IconAssets.location,
            value: stats.placesVisited.toString(),
            label: 'الزيارات',
          ),
        ),
        SizedBox(width: AppWidth.s10),
        Expanded(
          child: PerfStatBox(
            iconAsset: IconAssets.commit,
            value: '${stats.commitmentPct.round()}%',
            label: 'الالتزام',
          ),
        ),
      ],
    );
  }
}
