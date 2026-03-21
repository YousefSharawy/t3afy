import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    this.onProfileTap,
  });

  final VoidCallback? onProfileTap;

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
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Image.asset(
              IconAssets.volHome,
              width: AppWidth.s24,
              height: AppHeight.s24,
            ),
          ),
        ),
        Text(
          'الرئيسية',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.natural900,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(width: AppWidth.s44),
      ],
    );
  }
}
