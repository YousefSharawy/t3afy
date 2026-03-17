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
  });

  final String label;
  final double hours;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${hours.round()}h',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.blueThree300,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: AppHeight.s6),
        Container(
          width: 60.sp,
          height: (55 * ratio).sp,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.cyanPrimary,
                Color(0xFF02389E),
              ],
            ),
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
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.blueTwo100,
            fontSize: FontSize.s11,
          ),
        ),
      ],
    );
  }
}
