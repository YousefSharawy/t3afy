import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ReadonlyField extends StatelessWidget {
  const ReadonlyField({
    super.key,
    required this.value,
    required this.icon,
    this.label,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
  });

  final String value;
  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final field = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s14,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s10),
        border: Border.all(color: borderColor ?? ColorManager.blueOne700),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: textColor ?? Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          Icon(icon, color: iconColor ?? ColorManager.blueTwo200, size: 16.r),
        ],
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s12,
            color: ColorManager.natural400,
          ),
        ),
        SizedBox(height: AppHeight.s6),
        field,
      ],
    );
  }
}
