import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminStatBox extends StatelessWidget {
  const AdminStatBox({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor = ColorManager.mintGreen,
  });

  final String icon;
  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s16,
        horizontal: AppWidth.s8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        children: [
          Image.asset(icon, width: AppWidth.s24, height: AppHeight.s24),
          SizedBox(height: AppHeight.s2),
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.blueOne100,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
