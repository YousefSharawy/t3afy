import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
              Image.asset(
                IconAssets.camp,
                width: AppWidth.s36,
                height: AppHeight.s36,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      StatusBadge(status: task.status),
                      SizedBox(width: AppWidth.s3),
                      TaskTypeBadge(type: task.type),
                    ],
                  ),
                  SizedBox(height: AppHeight.s4),
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

              if (task.durationHours != null) ...[
                SizedBox(width: AppWidth.s20),
                TaskInfoRow(
                  color: ColorManager.natural50,
                  icon: IconAssets.alarm,
                  label:
                      '${task.durationHours!.toStringAsFixed(task.durationHours! == task.durationHours!.roundToDouble() ? 0 : 1)} ساعة',
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
}
