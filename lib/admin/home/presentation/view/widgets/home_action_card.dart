import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppHeight.s86,
        padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(icon),
            Text(
              label,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s11,
                color: ColorManager.primary600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
