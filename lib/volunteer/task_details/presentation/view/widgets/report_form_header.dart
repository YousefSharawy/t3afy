import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';

class ReportFormHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const ReportFormHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s16,
                  color: ColorManager.natural900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
