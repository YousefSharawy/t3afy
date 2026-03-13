import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.onProfileTap, this.onNotificationTap});

  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            padding: EdgeInsets.all(AppRadius.s10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.blueOne900, ColorManager.blueOne800],
              ),
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Image.asset(IconAssets.volHome,
            width: AppWidth.s24,
            height: AppHeight.s24,
            ),
          ),
        ),
         Text(
          'الرئيسية',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.blueOne900,
            fontSize: FontSize.s16,
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            padding: EdgeInsets.all(AppRadius.s10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: .topLeft,
                  end: .bottomRight,
                colors: [ColorManager.blueOne900, ColorManager.blueOne800],
              ),
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Image.asset(IconAssets.notification,
            width: AppWidth.s24,
            height: AppHeight.s24,
            ),
          ),
        ),
       
      ],
    );
  }
}
