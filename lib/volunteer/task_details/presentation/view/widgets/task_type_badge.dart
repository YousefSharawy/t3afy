import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class TaskTypeBadge extends StatelessWidget {
  const TaskTypeBadge({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s10,
        vertical: AppHeight.s4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.s20),
      ),
      child: Text(
        type,
        style: getMediumStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s11,
          color: Colors.white,
        ),
      ),
    );
  }
}
