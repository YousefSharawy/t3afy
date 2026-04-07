import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';

class ReportDivider extends StatelessWidget {
  const ReportDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: ColorManager.natural200);
  }
}
