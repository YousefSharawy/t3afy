import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class QuickActionChips extends StatelessWidget {
  const QuickActionChips({
    super.key,
    required this.actions,
    required this.onTap,
  });

  final List<String> actions;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.sp,
      runSpacing: 8.sp,
      alignment: WrapAlignment.center,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () => onTap(action),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 6.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.s20),
              border: Border.all(
                color: ColorManager.blueTwo200,
                width: 1.sp,
              ),
            ),
            child: Text(
              action,
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blueOne800,
                fontSize: FontSize.s10,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}