import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'qualification_row.dart';
import 'package:t3afy/base/widgets/info_row.dart';

class VolunteerDataTab extends StatefulWidget {
  const VolunteerDataTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<VolunteerDataTab> createState() => _VolunteerDataTabState();
}

class _VolunteerDataTabState extends State<VolunteerDataTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        InfoRow(
          icon: IconAssets.phone,
          label: 'رقم الهاتف',
          value: widget.details.phone ?? '—',
        ),
        InfoRow(
          icon: IconAssets.email2,
          label: 'البريد',
          value: widget.details.email ?? '—',
        ),
        InfoRow(
          icon: IconAssets.location,
          label: 'المنطقة',
          value: widget.details.region ?? '—',
        ),
        InfoRow(
          icon: IconAssets.calendar,
          label: 'تاريخ الانضمام',
          value: widget.details.joinedAt != null
              ? _formatArabicMonth(widget.details.joinedAt!)
              : '—',
        ),
        InfoRow(
          icon: IconAssets.hours,
          label: 'آخر ظهور',
          value: widget.details.lastSeenAt != null
              ? _timeAgo(widget.details.lastSeenAt!)
              : '—',
        ),
        QualificationRow(
          values: widget.details.volunteerAreas,
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
