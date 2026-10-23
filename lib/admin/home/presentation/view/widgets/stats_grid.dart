import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';

/// The four KPI tiles on the Manager command band.
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.activeTodayCount,
    required this.totalVolunteers,
    required this.completedCampaigns,
    required this.totalHours,
    required this.volunteersThisMonth,
    required this.activeDiffFromYesterday,
    required this.hoursPercentChange,
  });

  final int activeTodayCount;
  final int totalVolunteers;
  final int completedCampaigns;
  final double totalHours;
  final int volunteersThisMonth;
  final int activeDiffFromYesterday;
  final int hoursPercentChange;

  @override
  Widget build(BuildContext context) {
    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          SizedBox(width: Space.m),
          Expanded(child: b),
        ],
      ),
    );

    return Column(
      children: [
        row(
          StatTile(
            onDark: true,
            icon: AppIcons.vol,
            value: '$totalVolunteers',
            label: 'إجمالي المتطوعين',
            trend: volunteersThisMonth > 0
                ? '+$volunteersThisMonth هذا الشهر'
                : null,
            trendUp: true,
          ),
          StatTile(
            onDark: true,
            icon: AppIcons.boy,
            value: '$activeTodayCount',
            label: 'نشيط اليوم',
            trend: activeDiffFromYesterday == 0
                ? null
                : '${activeDiffFromYesterday.abs()} عن أمس',
            trendUp: activeDiffFromYesterday > 0,
          ),
        ),
        SizedBox(height: Space.vm),
        row(
          StatTile(
            onDark: true,
            icon: AppIcons.done2,
            value: '$completedCampaigns',
            label: 'حملة مكتملة',
          ),
          StatTile(
            onDark: true,
            icon: AppIcons.hours,
            value: totalHours.toStringAsFixed(0),
            label: 'ساعات التطوع',
            trend: hoursPercentChange == 0
                ? null
                : '${hoursPercentChange.abs()}% هذا الشهر',
            trendUp: hoursPercentChange > 0,
          ),
        ),
      ],
    );
  }
}
