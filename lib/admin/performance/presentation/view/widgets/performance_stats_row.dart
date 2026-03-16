import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PerformanceStatsRow extends StatelessWidget {
  const PerformanceStatsRow({super.key, required this.data});

  final AdminPerformanceEntity data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: IconAssets.group,
            value: '${data.totalVolunteers}',
            label: 'متطوع',
          ),
        ),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: _StatBox(
            icon: IconAssets.hours,
            value: '${data.totalHours}',
            label: 'ساعة',
          ),
        ),
        SizedBox(width: AppWidth.s8),
        Expanded(
          child: _StatBox(
            icon: IconAssets.star,
            value: data.avgRating.toStringAsFixed(1),
            label: 'متوسط التقييم',
            valueColor: const Color(0xFFFBBF24),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor = const Color(0xFF00ABD2),
  });

  final String icon;
  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s16,
        horizontal: AppWidth.s8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        children: [
          Image.asset(icon, width: AppWidth.s24, height: AppHeight.s24),
          SizedBox(height: AppHeight.s2),
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: Color(0xff00C9A7),
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.blueOne100,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
