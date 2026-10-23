import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

class TaskTypeBadge extends StatelessWidget {
  const TaskTypeBadge({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Space.m * 0.85,
        vertical: Space.vxs,
      ),
      decoration: BoxDecoration(
        color: ColorManager.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.chip),
        border: Border.all(color: ColorManager.line),
      ),
      child: Text(
        type,
        style: getMediumStyle(
          fontSize: FontSize.s12,
          color: ColorManager.inkMuted,
        ),
      ),
    );
  }
}
