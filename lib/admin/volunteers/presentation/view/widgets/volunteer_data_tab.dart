import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
          icon: IconAssets.phone,
          label: 'رقم الهاتف',
          value: details.phone ?? '—',
        ),
        _InfoRow(
          icon: IconAssets.email2,
          label: 'البريد',
          value: details.email ?? '—',
        ),
        _InfoRow(
          icon: IconAssets.location,
          label: 'المنطقة',
          value: details.region ?? '—',
        ),
        _InfoRow(
          icon: IconAssets.calendar,
          label: 'تاريخ الانضمام',
          value: details.joinedAt != null
              ? _formatArabicMonth(details.joinedAt!)
              : '—',
        ),
        _InfoRow(
          icon: IconAssets.hours,
          label: 'آخر ظهور',
          value: details.lastSeenAt != null
              ? _timeAgo(details.lastSeenAt!)
              : '—',
        ),
        _QualificationRow(
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
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
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: Color(0xff1F2E4F),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset(icon),
          ),
          SizedBox(width: AppWidth.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.blueOne100,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color:  ColorManager.blueOne50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QualificationRow extends StatelessWidget {
  const _QualificationRow({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مجالات التطوع',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 6.h),
                values.isEmpty
                    ? Text(
                        '—',
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s13,
                          color: Colors.white,
                        ),
                      )
                    : Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: values
                            .map(
                              (v) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF0D9488),
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  v,
                                  style: getRegularStyle(
                                    fontFamily: FontConstants.fontFamily,
                                    fontSize: FontSize.s11,
                                    color: const Color(0xFF2DD4BF),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
