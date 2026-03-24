import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PerfStatBox extends StatelessWidget {
  const PerfStatBox({
    super.key,
    this.iconAsset,
    required this.value,
    required this.label,
    this.decoration,
  });

  final String? iconAsset;
  final String value;
  final String label;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s12,
      ),
      decoration: decoration ??
          BoxDecoration(
           color: ColorManager.primary100,
            borderRadius: BorderRadius.circular(AppRadius.s16),
           
          ),
      child: Column(
        children: [
          if (iconAsset != null) ...[
            Image.asset(iconAsset!, width: AppWidth.s24, height: AppHeight.s24),
            SizedBox(height: AppHeight.s5),
          ],
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.primary500
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural400,
              fontSize: FontSize.s12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
