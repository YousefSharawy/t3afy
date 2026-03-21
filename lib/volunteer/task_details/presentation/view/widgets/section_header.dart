import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, this.icon, required this.title});

  final String? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Image.asset(icon!, width: AppWidth.s24, height: AppHeight.s24),
        ],
        SizedBox(width: AppWidth.s4),
        Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s12,
            color: ColorManager.natural600,
          ),
        ),
      ],
    );
  }
}
