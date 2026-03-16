import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
              child: _StatCard(
                icon: IconAssets.hours,
                iconColor: ColorManager.blueThree400,
                value: totalHours.toString(),
                label: 'ساعات التطوع',
              ),
            ),
            SizedBox(width: AppWidth.s18),
            Expanded(
              child: _StatCard(
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
              child: _StatCard(
                icon: IconAssets.done,
                iconColor: ColorManager.blueThree300,
                value: totalTasks.toString(),
                label: 'مهام منجزة',
              ),
            ),
            SizedBox(width: AppWidth.s18),
            Expanded(
              child: _StatCard(
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
              child: _StatCard(
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final String icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        vertical: AppHeight.s12,
        horizontal: AppWidth.s12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .bottomRight,
          end: .topLeft,
          colors: [ColorManager.blueOne700, ColorManager.blueOne900],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Image.asset(icon),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s20,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueTwo100,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }
}
