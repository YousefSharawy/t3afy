import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
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
    this.isRequired = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppText.label(color: ColorManager.error),
                ),
            ],
          ),
          style: AppText.label(color: ColorManager.ink),
        ),
        SizedBox(height: Space.vs),
        PrimaryTextFF(
          hint: hint ?? '',
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next,
        ),
      ],
    );
  }
}
