import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'task_info_row.dart';
import 'task_status_badge.dart';
import 'task_type_badge.dart';

class TaskDetailsHeaderCard extends StatelessWidget {
  const TaskDetailsHeaderCard({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
                child: Icon(
                  Icons.volunteer_activism_outlined,
                  color: Colors.white,
                  size: 26.r,
                ),
              ),
              const Spacer(),
              TaskStatusBadge(status: task.status),
              SizedBox(width: AppWidth.s8),
              TaskTypeBadge(type: task.type),
            ],
          ),
          SizedBox(height: AppHeight.s14),
          Text(
            task.title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s14),
          TaskInfoRow(
            icon: Icons.calendar_today_outlined,
            label: _formatArabicDate(task.date),
          ),
          SizedBox(height: AppHeight.s8),
          TaskInfoRow(
            icon: Icons.access_time_outlined,
            label: '${_formatTime(task.timeEnd)} - ${_formatTime(task.timeStart)}',
          ),
          SizedBox(height: AppHeight.s8),
          Row(
            children: [
              TaskInfoRow(
                icon: Icons.star_outline_rounded,
                label: '+${task.points} نقطة',
              ),
              if (task.durationHours != null) ...[
                SizedBox(width: AppWidth.s20),
                TaskInfoRow(
                  icon: Icons.hourglass_empty_outlined,
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
