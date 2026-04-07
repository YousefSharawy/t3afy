import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({
    super.key,
    required this.name,
    required this.level,
    required this.levelTitle,
  });

  final String name;
  final int level;
  final String levelTitle;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    return 'مساء الخير';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s20,
      ),
      decoration: BoxDecoration(
        color: ColorManager.primary50,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural400,
              fontSize: FontSize.s11,
            ),
          ),
          SizedBox(height: AppHeight.s2),
          Text(
            name,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural800,
              fontSize: FontSize.s20,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s12,
              vertical: AppHeight.s4,
            ),
            decoration: BoxDecoration(
              color: ColorManager.primary100,
              borderRadius: BorderRadius.circular(AppRadius.s16),
            ),
            child: Text(
              '$levelTitle المستوى $level',
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.primary600,
                fontSize: FontSize.s10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
