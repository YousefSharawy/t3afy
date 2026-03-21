import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ProfileBadge extends StatelessWidget {
  const ProfileBadge({
    super.key,
    required this.label,
    required this.color,
    required this.borderColor,
  });

  final String label;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.s25),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          color: ColorManager.white,
          fontSize: FontSize.s10,
        ),
      ),
    );
  }
}
