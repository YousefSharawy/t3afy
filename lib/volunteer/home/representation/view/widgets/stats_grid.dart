import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'home_stat_card.dart';

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
        Row(
          children: [
            Expanded(
              child: HomeStatCard(
                icon: IconAssets.hours,
                iconColor: ColorManager.blueThree400,
                value: totalHours.toString(),
                label: 'ساعات التطوع',
              ),
            ),
            SizedBox(width: AppWidth.s18),
            Expanded(
              child: HomeStatCard(
                icon: IconAssets.location,
                iconColor: Colors.pinkAccent,
                value: placesVisited.toString(),
                label: 'أماكن مزارة',
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s12),
        Row(
          children: [
            Expanded(
              child: HomeStatCard(
                icon: IconAssets.done,
                iconColor: ColorManager.blueThree300,
                value: totalTasks.toString(),
                label: 'مهام منجزة',
              ),
            ),
            SizedBox(width: AppWidth.s18),
            Expanded(
              child: HomeStatCard(
                icon: IconAssets.star,
                iconColor: Colors.amber,
                value: rating.toStringAsFixed(1),
                label: 'التقييم',
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s12),
        Row(
          children: [
            Expanded(
              child: HomeStatCard(
                icon: IconAssets.trophy,
                iconColor: Colors.orangeAccent,
                value: totalPoints.toString(),
                label: 'النقاط المكتسبة',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
