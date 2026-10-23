import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/core/utils/date_ar.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'task_type_badge.dart';

class TaskDetailsHeaderCard extends StatelessWidget {
  const TaskDetailsHeaderCard({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    final status = task.assignmentStatus ?? task.status;
    final hours = _durationHours();
    return AppCard(
      accent: StatusBadge.styleOf(status).accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconBadge(icon: AppIcons.taskType(task.type), size: 44),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: Space.xs,
                      runSpacing: Space.vxs,
                      children: [
                        StatusBadge(status: status),
                        TaskTypeBadge(type: task.type),
                      ],
                    ),
                    SizedBox(height: Space.vs),
                    Text(
                      task.title,
                      style: getDisplayStyle(
                        fontSize: 19,
                        color: ColorManager.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Space.vl),
          Wrap(
            spacing: Space.l,
            runSpacing: Space.vs,
            children: [
              MetaItem(icon: AppIcons.calendar, text: _formatDate(task.date)),
              MetaItem(
                icon: AppIcons.alarm,
                text: DateAr.timeRange(task.timeStart, task.timeEnd),
              ),
              if (hours > 0)
                MetaItem(
                  icon: AppIcons.hours,
                  text:
                      '${hours.toStringAsFixed(hours == hours.roundToDouble() ? 0 : 1)} ساعة',
                ),
            ],
          ),
          SizedBox(height: Space.vm),
          _PointsChip(points: task.points),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return date;
    return '${DateAr.weekday(d)}، ${DateAr.date(d)}';
  }

  double _durationHours() {
    if (task.durationHours != null && task.durationHours! > 0) {
      return task.durationHours!;
    }
    try {
      final s = task.timeStart.split(':');
      final e = task.timeEnd.split(':');
      if (s.length < 2 || e.length < 2) return 0;
      final startMin =
          (int.tryParse(s[0]) ?? 0) * 60 + (int.tryParse(s[1]) ?? 0);
      final endMin = (int.tryParse(e[0]) ?? 0) * 60 + (int.tryParse(e[1]) ?? 0);
      final diff = endMin - startMin;
      return diff > 0 ? (diff / 60.0 * 10).round() / 10.0 : 0;
    } catch (_) {
      return 0;
    }
  }
}

class _PointsChip extends StatelessWidget {
  const _PointsChip({required this.points});
  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Space.m,
        vertical: Space.vxs + 1,
      ),
      decoration: BoxDecoration(
        color: ColorManager.starSoft,
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(AppIcons.star, size: 16, color: ColorManager.star),
          SizedBox(width: Space.xs),
          Text(
            '+$points نقطة',
            style: getNumericStyle(
              fontSize: 13,
              color: ColorManager.starText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
