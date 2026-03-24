import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerStatsBox extends StatelessWidget {
  const VolunteerStatsBox({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s8,
        horizontal: AppWidth.s6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.primary50,
        borderRadius: BorderRadius.circular(AppRadius.s10),
      ),
      child: Column(
        children: [
          SizedBox(height: AppHeight.s4),
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: color,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural400,
            ),
          ),
        ],
      ),
    );
  }
}
