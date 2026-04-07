import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppHeight.s50,
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
            Image.asset(icon),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: titleColor ?? ColorManager.natural900,
                    ),
                  ),
                  SizedBox(height: AppHeight.s3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
