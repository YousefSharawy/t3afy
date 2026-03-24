import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerDetailStatBox extends StatelessWidget {
  const VolunteerDetailStatBox({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppWidth.s99,
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s8,
        horizontal: AppWidth.s32,
      ),
      decoration: BoxDecoration(
        color: ColorManager.primary50,
        borderRadius: BorderRadius.circular(AppRadius.s8),
        border: Border.all(width: 1.sp,color: ColorManager.primary200)
      ),
      child: Column(
        children: [
          Image.asset(icon, width: AppWidth.s24, height: AppHeight.s24),
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.primary500,
            ),
          ),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.natural400,
            ),
          ),
        ],
      ),
    );
  }
}
