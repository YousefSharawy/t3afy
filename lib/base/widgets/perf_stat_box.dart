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
           color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            border: Border.all(
              color: ColorManager.blueThree500.withValues(alpha: 0.3),
            ),
          ),
      child: Column(
        children: [
          if (iconAsset != null) ...[
            Image.asset(iconAsset!, width: 28, height: 28),
            SizedBox(height: AppHeight.s6),
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
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural300,
              fontSize: FontSize.s12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
