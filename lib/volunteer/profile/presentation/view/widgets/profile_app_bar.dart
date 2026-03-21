import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: ColorManager.black,
            size: 24.sp,
          ),
        ),
        Text(
          'الملف الشخصي',
          style: getExtraBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.natural900,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(width: 36.w),
      ],
    );
  }
}
