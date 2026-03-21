import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class GradientCard extends StatelessWidget {
  const GradientCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s12),
      decoration: BoxDecoration(
       color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: child,
    );
  }
}
