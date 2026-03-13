import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        gradient: LinearGradient(
         begin: .bottomRight,
         end: .topLeft,
          colors: [ColorManager.blueOne900, ColorManager.blueOne800],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueOne50,
              fontSize: FontSize.s11,
            ),
          ),
          SizedBox(height: AppHeight.s2),
          Text(
            name,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueOne50,
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
              color: Color(0xff0C8BA8),
              borderRadius: BorderRadius.circular(AppRadius.s25),
              border: Border.all(
                color: Color(0xff00FFDA)
              )
            ),
            child: Text(
              '$levelTitle المستوى $level',
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: Color(0xFF00FFDA),
                fontSize: FontSize.s10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
