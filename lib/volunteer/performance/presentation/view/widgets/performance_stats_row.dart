import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

class PerformanceStatsRow extends StatelessWidget {
  const PerformanceStatsRow({super.key, required this.stats});

  final PerformanceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatTile(
            icon: AppIcons.hours,
            value: '${stats.totalHours}',
            label: 'الساعات',
          ),
        ),
        SizedBox(width: Space.s),
        Expanded(
          child: StatTile(
            icon: AppIcons.location,
            tint: ColorManager.sproutText,
            value: '${stats.placesVisited}',
            label: 'الزيارات',
          ),
        ),
        SizedBox(width: Space.s),
        Expanded(
          child: StatTile(
            icon: AppIcons.trophy,
            tint: ColorManager.info,
            value: '${stats.totalPoints}',
            label: 'النقاط',
          ),
        ),
      ],
    );
  }
}
