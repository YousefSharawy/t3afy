import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerDataTab extends StatelessWidget {
  const VolunteerDataTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s8,
      ),
      children: [
        _InfoRow(
          icon: Icons.phone_outlined,
          label: 'رقم الهاتف',
          value: details.phone ?? '—',
        ),
        _InfoRow(
          icon: Icons.email_outlined,
          label: 'البريد',
          value: details.email ?? '—',
        ),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: 'المنطقة',
          value: details.region ?? '—',
        ),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'تاريخ الانضمام',
          value: details.joinedAt != null
              ? _formatArabicMonth(details.joinedAt!)
              : '—',
        ),
        _InfoRow(
          icon: Icons.access_time_outlined,
          label: 'آخر ظهور',
          value: details.lastSeenAt != null
              ? _timeAgo(details.lastSeenAt!)
              : '—',
        ),
        _InfoRow(
          icon: Icons.school_outlined,
          label: 'مجالات التطوع',
          value: details.qualification ?? '—',
        ),
      ],
    );
  }

  String _formatArabicMonth(DateTime dt) {
    const months = [
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
    return '${months[dt.month - 1]} ${dt.year}';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'منذ لحظات';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
    return 'منذ أكثر من شهر';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorManager.blueOne300, size: 18.r),
          SizedBox(width: AppWidth.s12),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.blueOne300,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: Colors.white,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
