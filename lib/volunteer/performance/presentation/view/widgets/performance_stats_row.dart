import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

class PerformanceStatsRow extends StatelessWidget {
  const PerformanceStatsRow({super.key, required this.stats});

  final PerformanceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            iconAsset: IconAssets.alarm,
            value: stats.totalHours.toString(),
            label: 'الساعات',
          ),
        ),
        SizedBox(width: AppWidth.s10),
        Expanded(
          child: _StatBox(
            iconAsset: IconAssets.location,
            value: stats.placesVisited.toString(),
            label: 'الزيارات',
          ),
        ),
        SizedBox(width: AppWidth.s10),
        Expanded(
          child: _StatBox(
            iconAsset: IconAssets.commit,
            value: '${stats.commitmentPct.round()}%',
            label: 'الالتزام',
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.iconAsset,
    required this.value,
    required this.label,
  });

  final String iconAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s14,
        horizontal: AppWidth.s8,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: ColorManager.blueThree500.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Image.asset(iconAsset, width: 28.sp, height: 28.sp),
          SizedBox(height: AppHeight.s6),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s18,
            ),
          ),
          SizedBox(height: AppHeight.s2),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueTwo100,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
    );
  }
}
