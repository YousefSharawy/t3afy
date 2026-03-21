import 'package:flutter/material.dart';
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
                value: totalHours.toString(),
                label: 'ساعات التطوع',
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: HomeStatCard(
                value: placesVisited.toString(),
                label: 'أماكن مزارة',
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          children: [
            Expanded(
              child: HomeStatCard(
                value: totalTasks.toString(),
                label: 'مهام منجزة',
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: HomeStatCard(
                value: rating.toStringAsFixed(1),
                label: 'التقييم',
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          children: [
            Expanded(
              child: HomeStatCard(
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
