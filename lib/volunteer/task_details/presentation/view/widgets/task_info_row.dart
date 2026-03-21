import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class TaskInfoRow extends StatelessWidget {
  const TaskInfoRow({
    super.key,
    this.icon,
    required this.label,
    required this.color,
    this.borderColor,
  });

  final String? icon;
  final String label;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s4,
        horizontal: AppWidth.s6,
      ),
      height: AppHeight.s27,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.s4),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Image.asset(icon!, width: AppWidth.s18, height: AppHeight.s18),
            SizedBox(width: AppWidth.s4),
          ],
          Text(
            label,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: borderColor ?? ColorManager.natural600,
            ),
          ),
        ],
      ),
    );
  }
}
