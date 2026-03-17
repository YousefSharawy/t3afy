import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'bar_column.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key, required this.monthlyHours});

  final List<MonthlyHoursEntity> monthlyHours;

  static const _monthNames = [
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

  @override
  Widget build(BuildContext context) {
    final maxHours = monthlyHours.isEmpty
        ? 1.0
        : monthlyHours
            .map((m) => m.hours)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1.0, double.infinity);

    return Container(
      width: double.infinity,
      height: 192.sp,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          Text(
            'ساعات التطوع الشهرية',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: AppHeight.s20),
          Expanded(
            child: monthlyHours.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد بيانات',
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blueTwo100,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: monthlyHours.map((m) {
                      final ratio = m.hours / maxHours;
                      final name = (m.month >= 1 && m.month <= 12)
                          ? _monthNames[m.month]
                          : '${m.month}';
                      return BarColumn(
                        label: name,
                        hours: m.hours,
                        ratio: ratio,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
