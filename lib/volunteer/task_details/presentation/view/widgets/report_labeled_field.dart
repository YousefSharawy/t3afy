import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class ReportLabeledField extends StatelessWidget {
  const ReportLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s14,
            color: ColorManager.natural600,
          ),
        ),
        SizedBox(height: AppHeight.s4),
        PrimaryTextFF(
          hint: hint ?? '',
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
