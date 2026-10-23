import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';

/// Five KPIs as a balanced 3 + 2 layout (the old 2 + 2 + 1 left an orphan).
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.placesVisited,
    required this.totalHours,
    required this.rating,
    required this.totalTasks,
    required this.totalPoints,
  });

  final int placesVisited;
  final int totalHours;
  final double rating;
  final int totalTasks;
  final int totalPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row([
          StatTile(
            value: '$totalHours',
            label: 'ساعات التطوع',
            icon: AppIcons.hours,
          ),
          StatTile(
            value: '$totalTasks',
            label: 'مهام منجزة',
            icon: AppIcons.done,
            tint: ColorManager.sprout,
          ),
          StatTile(
            value: '$placesVisited',
            label: 'أماكن مزارة',
            icon: AppIcons.location,
            tint: ColorManager.info,
          ),
        ]),
        SizedBox(height: Space.vm),
        _row([
          StatTile(
            value: '$totalPoints',
            label: 'النقاط المكتسبة',
            icon: AppIcons.medal,
            tint: ColorManager.brandStrong,
          ),
          StatTile(
            value: rating.toStringAsFixed(1),
            label: 'التقييم',
            icon: AppIcons.star,
            tint: ColorManager.star,
          ),
        ]),
      ],
    );
  }

  Widget _row(List<Widget> tiles) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) SizedBox(width: Space.m),
            Expanded(child: tiles[i]),
          ],
        ],
      ),
    );
  }
}
