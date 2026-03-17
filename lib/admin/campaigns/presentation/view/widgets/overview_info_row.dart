import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class OverviewInfoRow extends StatelessWidget {
  const OverviewInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s14,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        children: [
          Container(
            width: AppWidth.s32,
            height: AppHeight.s32,
            decoration: BoxDecoration(
              color: ColorManager.navyCard,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Image.asset(
              icon,
              width: AppWidth.s32,
              height: AppHeight.s32,
            ),
          ),
          SizedBox(width: AppWidth.s10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getLightStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.white,
                ),
              ),
              Text(
                value,
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
