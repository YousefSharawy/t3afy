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
    final color = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s10,
        vertical: AppHeight.s4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.s20),
        border: Border.all(color: color),
      ),
      child: Text(
        _statusLabel(status),
        style: getSemiBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s11,
          color: color,
        ),
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'active':
      case 'ongoing':
        return const Color(0xFF16A34A);
      case 'upcoming':
        return ColorManager.violet700;
      case 'done':
        return Colors.grey;
      case 'paused':
        return Colors.orange;
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
