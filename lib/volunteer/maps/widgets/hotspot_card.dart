import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class HotspotCard extends StatelessWidget {
  const HotspotCard({
    super.key,
    required this.name,
    required this.cases,
    required this.severity,
  });

  final String name;
  final int cases;
  final String severity;

  /// Returns [fillColor, textColor, borderColor] based on severity label.
  ({Color fill, Color text, Color border}) get _severityColors {
    if (severity == 'عالي') {
      return (
        fill: ColorManager.errorLight,
        text: ColorManager.error,
        border: ColorManager.error,
      );
    } else if (severity == 'متوسط') {
      return (
        fill: ColorManager.warningLight,
        text: ColorManager.warning,
        border: ColorManager.warning,
      );
    } else {
      // منخفض — low
      return (
        fill: ColorManager.infoLight,
        text: ColorManager.info,
        border: ColorManager.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _severityColors;
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(IconAssets.location),
          SizedBox(width: AppWidth.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural700,
                  fontSize: FontSize.s12,
                ),
              ),
              Text(
                '$cases ${cases == 1 ? 'حاله مرصودة' : 'حالات مرصودة'}',
                textAlign: TextAlign.right,
                style: getLightStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural400,
                  fontSize: FontSize.s10,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s10,
              vertical: AppHeight.s2,
            ),
            decoration: BoxDecoration(
              color: colors.fill,
              borderRadius: BorderRadius.circular(AppRadius.s6),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Text(
              severity,
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: colors.text,
                fontSize: FontSize.s11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
