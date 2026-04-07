import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AlertField extends StatelessWidget {
  const AlertField({
    super.key,
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
      style: getMediumStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s13,
        color: ColorManager.natural900,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s13,
          color: ColorManager.natural400,
        ),
        filled: true,
        fillColor: ColorManager.natural50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s12),
          borderSide: BorderSide(color: ColorManager.natural200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s12),
          borderSide: BorderSide(color: ColorManager.natural200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s12),
          borderSide: const BorderSide(color: ColorManager.cyanPrimary),
        ),
      ),
    );
  }
}
