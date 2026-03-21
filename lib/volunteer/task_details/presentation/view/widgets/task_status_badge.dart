import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class TaskStatusBadge extends StatelessWidget {
  const TaskStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final containerFillColor = _statusFillColor(status);
    final borderTextColor = _textBorderFillColor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s10,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: containerFillColor,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: borderTextColor),
      ),
      child: Text(
        _statusLabel(status),
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s10,
          color: borderTextColor,
        ),
      ),
    );
  }

  Color _statusFillColor(String s) {
    switch (s) {
      case 'active':
      case 'ongoing':
        return ColorManager.infoLight;
      case 'upcoming':
        return ColorManager.warningLight;
      case 'done':
        return ColorManager.successLight;
      case 'paused':
       return ColorManager.warningLight;
      default:
        return Colors.grey;
    }
  }
   Color _textBorderFillColor(String s) {
    switch (s) {
      case 'active':
      case 'ongoing':
        return ColorManager.info;
      case 'upcoming':
        return ColorManager.warning;
      case 'done':
        return ColorManager.success;
      case 'paused':
       return ColorManager.warning;
      default:
        return Colors.grey;
    }
  }



  String _statusLabel(String s) {
    switch (s) {
      case 'active':
      case 'ongoing':
        return 'جارية';
      case 'upcoming':
        return 'قادمة';
      case 'done':
        return 'مكتملة';
      case 'paused':
        return 'موقوفة';
      default:
        return s;
    }
  }
}
