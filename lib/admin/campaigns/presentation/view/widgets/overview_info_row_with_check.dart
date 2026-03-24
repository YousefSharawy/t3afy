import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class OverviewInfoRowWithCheck extends StatelessWidget {
  const OverviewInfoRowWithCheck({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.achieved,
  });

  final String icon;
  final String label;
  final String value;
  final bool achieved;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
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
          Column(
            children: [
              Text(
                label,
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.natural400,
                ),
              ),
               Text(
            value,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color:ColorManager.natural700,
            ),
          ),
            ],
          ),
          if (achieved) ...[
            SizedBox(width: AppWidth.s4),
           Image.asset(IconAssets.done2)
          ],
        ],
      ),
    );
  }
}
