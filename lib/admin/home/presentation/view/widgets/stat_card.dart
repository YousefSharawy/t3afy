import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.value,
    required this.label,
    this.trend,
  });
  final String icon;
  final String value;
  final String label;
  final String? trend;
  final Color iconBgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppWidth.s165,
      height: AppHeight.s142,
      padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.s16),
        color: ColorManager.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Image.asset(icon),
          ),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s20,
              color: ColorManager.primary500,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural300,
            ),
          ),
          if (trend != null) ...[
            Text(
              trend!,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: ColorManager.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
