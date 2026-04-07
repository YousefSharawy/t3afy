import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

class VolunteerTaskCard extends StatelessWidget {
  const VolunteerTaskCard({super.key, required this.task});

  final VolunteerTaskAssignmentEntity task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────
          Row(
            children: [
              Image.asset(
                _taskIcon(task.title),
                width: AppWidth.s24,
                height: AppHeight.s24,
                fit: BoxFit.cover,
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title.isNotEmpty ? task.title : 'مهمة',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: ColorManager.natural700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.assignedAt != null)
                      Text(
                        _formatDate(task.assignedAt!),
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.natural400,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusBadge(status: task.status),
                  if (task.isVerified) ...[
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 10.r,
                          color: ColorManager.success,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          task.verifiedHours != null
                              ? '${task.verifiedHours!.toStringAsFixed(1)} س'
                              : 'محقق',
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s9,
                            color: ColorManager.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),

          // ── Attendance badge + times (only if checked in) ────────
          if (task.checkedInAt != null) ...[
            Divider(
              height: AppHeight.s12,
              thickness: 0.5,
              color: ColorManager.natural200,
            ),
            _AttendanceBadge(task: task),
          ],
        ],
      ),
    );
  }

  String _taskIcon(String title) {
    if (title.contains('مستشفي')) return IconAssets.hospital;
    if (title.contains('توزيع')) return IconAssets.campaigns;
    return IconAssets.camp;
  }

  static const _months = [
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

  String _formatDate(DateTime dt) {
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }
}

class _AttendanceBadge extends StatelessWidget {
  const _AttendanceBadge({required this.task});

  final VolunteerTaskAssignmentEntity task;

  @override
  Widget build(BuildContext context) {
    final checkedIn = task.checkedInAt;
    final checkedOut = task.checkedOutAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Status badge ─────────────────────────────────────────
        _StatusChip(isVerified: task.isVerified, checkedOut: checkedOut),
        SizedBox(height: AppHeight.s6),

        // ── Times row ────────────────────────────────────────────
        Row(
          children: [
            Icon(
              Icons.login_rounded,
              size: 11.r,
              color: ColorManager.natural400,
            ),
            SizedBox(width: 3.w),
            Text(
              'حضور: ${formatTimeArabic(checkedIn)}',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: ColorManager.natural500,
              ),
            ),
            if (checkedOut != null) ...[
              SizedBox(width: AppWidth.s10),
              Icon(
                Icons.logout_rounded,
                size: 11.r,
                color: ColorManager.natural400,
              ),
              SizedBox(width: 3.w),
              Text(
                'انصراف: ${formatTimeArabic(checkedOut)}',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.natural500,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isVerified, required this.checkedOut});

  final bool isVerified;
  final DateTime? checkedOut;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color textColor;
    final Color bgColor;
    final Color borderColor;

    if (isVerified) {
      label = '✓ حضور مؤكد';
      textColor = ColorManager.success;
      bgColor = ColorManager.successLight;
      borderColor = ColorManager.success;
    } else {
      label = 'حضر — لم يتم التحقق';
      textColor = ColorManager.warning;
      bgColor = ColorManager.warningLight;
      borderColor = ColorManager.warning;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s8,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: borderColor, width: 0.5.sp),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s10,
          color: textColor,
        ),
      ),
    );
  }
}
