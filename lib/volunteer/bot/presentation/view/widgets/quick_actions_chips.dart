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
    if (actions.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 4.sp,
      runSpacing: 8.sp,
      alignment: WrapAlignment.start,
      children: actions.map((action) {
        return GestureDetector(
          onTap: () => onTap(action),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s12,
              vertical: AppHeight.s2,
            ),
            decoration: BoxDecoration(
              color: ColorManager.primary500,
              borderRadius: BorderRadius.circular(AppRadius.s16),
            ),
            child: Text(
              action,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural50,
                fontSize: FontSize.s10,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
