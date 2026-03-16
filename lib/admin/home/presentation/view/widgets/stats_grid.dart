import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/stat_card.dart';

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
    final volunteersTrend =
        volunteersThisMonth > 0 ? '↑$volunteersThisMonth هذا الشهر' : null;

    final String? activeTrend;
    if (activeDiffFromYesterday > 0) {
      activeTrend = '↑$activeDiffFromYesterday عن أمس';
    } else if (activeDiffFromYesterday < 0) {
      activeTrend = '↓${activeDiffFromYesterday.abs()} عن أمس';
    } else {
      activeTrend = null;
    }

    final String? hoursTrend;
    if (hoursPercentChange > 0) {
      hoursTrend = '↑$hoursPercentChange% هذا الشهر';
    } else if (hoursPercentChange < 0) {
      hoursTrend = '↓${hoursPercentChange.abs()}% هذا الشهر';
    } else {
      hoursTrend = null;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: IconAssets.group,
                value: '$totalVolunteers',
                label: 'اجمالي المتطوعين',
                trend: volunteersTrend,
              ),
            ),
            SizedBox(width: AppWidth.s18),
            Expanded(
              child: StatCard(
                icon: IconAssets.boy,
                value: '$activeTodayCount',
                label: 'نشيط اليوم',
                trend: activeTrend,
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: IconAssets.hours,
                value: '$completedCampaigns',
                label: 'حملة مكتملة',
              ),
            ),
            SizedBox(width: AppWidth.s18),
            Expanded(
              child: StatCard(
                icon: IconAssets.done,
                value: totalHours.toStringAsFixed(0),
                label: 'ساعات التطوع',
                trend: hoursTrend,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
