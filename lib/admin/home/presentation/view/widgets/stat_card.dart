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
    required this.value,
    required this.label,
    this.trend,
  });
  final String icon;
  final String value;
  final String label;
  final String? trend;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppWidth.s160,
      height: AppHeight.s150,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s35,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.blueOne700),
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [ColorManager.blueOne900, ColorManager.blueOne800],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: ColorManager.blueOne700,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Image.asset(icon),
          ),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s20,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.blueOne100,
            ),
          ),
          if (trend != null) ...[
            Text(
              trend!,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: const Color(0xFF66F839),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
