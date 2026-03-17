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
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorManager.blueOne900,
              ColorManager.blueOne800,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Row(
          children: [
            Container(
              width: AppWidth.s32,
              height: AppHeight.s32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.s8),
                color: ColorManager.navyCard,
              ),
              child: Image.asset(icon),
            ),
            SizedBox(width: AppWidth.s8),
            Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.blueOne50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
