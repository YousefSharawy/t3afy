import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PerfStatBox extends StatelessWidget {
  const PerfStatBox({
    super.key,
    required this.iconAsset,
    required this.value,
    required this.label,
  });

  final String iconAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s14,
        horizontal: AppWidth.s8,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: ColorManager.blueThree500.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Image.asset(iconAsset, width: 28, height: 28),
          SizedBox(height: AppHeight.s6),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s18,
            ),
          ),
          SizedBox(height: AppHeight.s2),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueTwo100,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
    );
  }
}
