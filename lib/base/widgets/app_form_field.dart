import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.hintColor,
    this.prefixIcon,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveFill = fillColor ?? ColorManager.blueOne800;
    final effectiveBorder = borderColor ?? ColorManager.blueOne700;
    final effectiveFocused = focusedBorderColor ?? ColorManager.cyanPrimary;
    final effectiveText = textColor ?? Colors.white;
    final effectiveHint =
        hintColor ?? Colors.white.withValues(alpha: 0.3);

    final field = TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      style: getMediumStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s13,
        color: effectiveText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s13,
          color: effectiveHint,
        ),
        filled: true,
        fillColor: effectiveFill,
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppWidth.s12,
          vertical: AppHeight.s12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s23),
          borderSide: BorderSide(color: effectiveBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s23),
          borderSide: BorderSide(color: effectiveBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s23),
          borderSide: BorderSide(color: effectiveFocused),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.s23),
          borderSide: const BorderSide(color: ColorManager.error),
        ),
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
