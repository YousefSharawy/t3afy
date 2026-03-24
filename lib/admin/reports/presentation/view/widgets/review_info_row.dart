import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ReviewInfoRow extends StatelessWidget {
  const ReviewInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [ Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s12,
            color: ColorManager.natural400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: valueColor ?? ColorManager.natural900,
          ),
        ),
       
      ],
    );
  }
}
