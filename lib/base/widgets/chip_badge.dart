import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ChipBadge extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;
  final Color borderColor;
  final Color fillColor;
  final Widget? trailing;

  const ChipBadge(
    this.text, {
    super.key,
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.fillColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s10,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: borderColor, width: 0.5.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: AppWidth.s16, height: AppHeight.s16),
          SizedBox(width: AppWidth.s4),
          Text(
            text,
            style: getBoldStyle(
              fontSize: FontSize.s10,
              fontFamily: FontConstants.fontFamily,
              color: color,
            ),
          ),
          SizedBox(width: AppWidth.s4),
        ],
      ),
    );
  }
}
