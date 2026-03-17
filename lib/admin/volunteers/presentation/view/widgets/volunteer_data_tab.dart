import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'qualification_row.dart';
import 'volunteer_info_row.dart';

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
        VolunteerInfoRow(
          icon: IconAssets.phone,
          label: 'رقم الهاتف',
          value: details.phone ?? '—',
        ),
        VolunteerInfoRow(
          icon: IconAssets.email2,
          label: 'البريد',
          value: details.email ?? '—',
        ),
        VolunteerInfoRow(
          icon: IconAssets.location,
          label: 'المنطقة',
          value: details.region ?? '—',
        ),
        VolunteerInfoRow(
          icon: IconAssets.calendar,
          label: 'تاريخ الانضمام',
          value: details.joinedAt != null
              ? _formatArabicMonth(details.joinedAt!)
              : '—',
        ),
        VolunteerInfoRow(
          icon: IconAssets.hours,
          label: 'آخر ظهور',
          value: details.lastSeenAt != null
              ? _timeAgo(details.lastSeenAt!)
              : '—',
        ),
        QualificationRow(
          values: details.volunteerAreas,
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
