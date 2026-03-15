import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import '../../../domain/entities/task_details_entity.dart';

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
              _StatusBadge(status: task.status),
              SizedBox(width: AppWidth.s8),
              _TypeBadge(type: task.type),
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
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: _formatArabicDate(task.date),
          ),
          SizedBox(height: AppHeight.s8),
          _InfoRow(
            icon: Icons.access_time_outlined,
            label: '${_formatTime(task.timeEnd)} - ${_formatTime(task.timeStart)}',
          ),
          SizedBox(height: AppHeight.s8),
          Row(
            children: [
              _InfoRow(
                icon: Icons.star_outline_rounded,
                label: '+${task.points} نقطة',
              ),
              if (task.durationHours != null) ...[
                SizedBox(width: AppWidth.s20),
                _InfoRow(
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF2DD4BF), size: 16.r),
        SizedBox(width: AppWidth.s6),
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

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
        return const Color(0xFF7C3AED);
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

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

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
