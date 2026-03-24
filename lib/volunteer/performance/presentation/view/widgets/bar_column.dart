import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class BarColumn extends StatelessWidget {
  const BarColumn({
    super.key,
    required this.label,
    required this.hours,
    required this.ratio,
    required this.barWidth,
  });

  final String label;
  final double hours;
  final double ratio;
  final double barWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${hours.round()}h',
          style: getBlackStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.primary500,
            fontSize: FontSize.s13,
          ),
        ),
        SizedBox(height: AppHeight.s6),
        Container(
          width: barWidth,
          height: (55 * ratio).sp,
          decoration: BoxDecoration(
        color: ColorManager.primary500,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.sp),
              topRight: Radius.circular(8.sp),
              bottomLeft: Radius.circular(4.sp),
              bottomRight: Radius.circular(4.sp),
            ),
          ),
        ),
        SizedBox(height: AppHeight.s8),
        Text(
          label,
          style: getLightStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.natural400,
            fontSize: FontSize.s12,
          ),
        ),
      ],
    );
  }
}
