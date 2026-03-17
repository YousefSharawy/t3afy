import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s6,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne700,
        borderRadius: BorderRadius.circular(AppRadius.s20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: AppWidth.s14, height: AppHeight.s14),
          SizedBox(width: AppWidth.s4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.blueTwo100,
            ),
          ),
        ],
      ),
    );
  }
}
