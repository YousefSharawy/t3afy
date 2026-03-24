import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getSemiBoldStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s14,
        color: ColorManager.natural900,
      ).copyWith(letterSpacing: -0.5),
    );
  }
}
