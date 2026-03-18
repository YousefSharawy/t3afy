import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.labelColor = ColorManager.blueOne100,
    this.valueColor = ColorManager.blueOne50,
  });

  final String icon;
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: ColorManager.navyCard,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset(icon),
          ),
          SizedBox(width: AppWidth.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: labelColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
