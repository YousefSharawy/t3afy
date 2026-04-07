import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerActionRow extends StatelessWidget {
  const VolunteerActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppHeight.s50,
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s12,
          vertical: AppHeight.s8,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: AppWidth.s24,
              height: AppHeight.s24,
              fit: BoxFit.contain,
            ),
            SizedBox(width: AppWidth.s8),
            Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.natural700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
