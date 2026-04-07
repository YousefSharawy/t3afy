import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.activeVolunteersCount});

  final int activeVolunteersCount;

  static String _formatDate(DateTime d) {
    const weekdays = [
      'الإثنين',
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
    final weekday = weekdays[d.weekday - 1];
    return 'اليوم, $weekday ${d.day} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s24,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                _formatDate(DateTime.now()),
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.natural400,
                ),
              ),
              SizedBox(height: AppHeight.s4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      color: ColorManager.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: AppWidth.s6),
                  Text(
                    '$activeVolunteersCount متطوع نشيط الآن',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s12,
                      color: ColorManager.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s8,
              vertical: AppHeight.s4,
            ),
            decoration: BoxDecoration(
              color: ColorManager.successLight,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Text(
              'النظام يعمل ✓',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: ColorManager.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
