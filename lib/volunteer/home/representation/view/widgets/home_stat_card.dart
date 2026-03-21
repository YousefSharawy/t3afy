import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        vertical: AppHeight.s12,
        horizontal: AppWidth.s12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .bottomRight,
          end: .topLeft,
          colors: [ColorManager.primary500, ColorManager.primary300],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppHeight.s4),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s20,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }
}
