import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'task_info_row.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'task_type_badge.dart';

class TaskDetailsHeaderCard extends StatelessWidget {
  const TaskDetailsHeaderCard({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s12),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppWidth.s36,
                height: AppHeight.s36,
                decoration: BoxDecoration(
                  color: ColorManager.natural100,
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Icon(
                  taskTypeIcon(task.type),
                  size: 20.sp,
                  color: ColorManager.natural600,
                ),
              ),
              SizedBox(width: AppWidth.s8),

              Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    
                    children: [
                      StatusBadge(status: task.assignmentStatus ?? task.status),
                      TaskTypeBadge(type: task.type),
                    ],
                  ),
                  SizedBox(height: AppHeight.s3),
                  Text(
                    task.title,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: ColorManager.natural600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppHeight.s8),
          Row(
            children: [
              TaskInfoRow(
                color: ColorManager.natural50,
                label: _formatArabicDate(task.date),
              ),
              SizedBox(width: AppWidth.s8),
              TaskInfoRow(
                color: ColorManager.natural50,
                icon: IconAssets.hours,
                label:
                    '${_formatTime(task.timeEnd)} - ${_formatTime(task.timeStart)}',
              ),
            ],
          ),
          SizedBox(height: AppHeight.s4),
          Row(
            children: [
              TaskInfoRow(
                icon: IconAssets.medal,
                label: '+${task.points} نقطة',
                color: ColorManager.warningLight,
                borderColor: ColorManager.warning,
              ),

              if (_getDurationHours() > 0) ...[
                SizedBox(width: AppWidth.s8),
                TaskInfoRow(
                  color: ColorManager.natural50,
                  icon: IconAssets.alarm,
                  label:
                      '${_getDurationHours().toStringAsFixed(_getDurationHours() == _getDurationHours().roundToDouble() ? 0 : 1)} ساعة',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatArabicDate(String date) {
    try {
      final d = DateTime.parse(date);
      const days = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
      const months = [
        '',
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      return '${days[d.weekday - 1]} ${d.day} ${months[d.month]} ${d.year}';
    } catch (_) {
      return date;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1].padLeft(2, '0');
      final period = hour >= 12 ? 'م' : 'ص';
      final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$h:$minute $period';
    } catch (_) {
      return time;
    }
  }

  double _getDurationHours() {
    if (task.durationHours != null && task.durationHours! > 0) {
      return task.durationHours!;
    }
    return _calculateDuration(task.timeStart, task.timeEnd);
  }

  double _calculateDuration(String timeStart, String timeEnd) {
    try {
      final startParts = timeStart.split(':');
      final endParts = timeEnd.split(':');
      if (startParts.length < 2 || endParts.length < 2) return 0;
      final startMin = (int.tryParse(startParts[0]) ?? 0) * 60 + (int.tryParse(startParts[1]) ?? 0);
      final endMin = (int.tryParse(endParts[0]) ?? 0) * 60 + (int.tryParse(endParts[1]) ?? 0);
      final diff = endMin - startMin;
      return diff > 0 ? (diff / 60.0 * 10).round() / 10.0 : 0;
    } catch (_) {
      return 0;
    }
  }
}
