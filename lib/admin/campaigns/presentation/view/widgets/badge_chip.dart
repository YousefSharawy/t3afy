import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s8,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: ColorManager.primary50,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: ColorManager.primary500, width: 0.5.sp),
      ),
      child: Text(
        label,
        style: getSemiBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s10,
          color: ColorManager.primary500,
        ),
      ),
    );
  }
}
