import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'bar_column.dart';
import 'package:t3afy/base/widgets/after_transition.dart';

/// Hours for the last three calendar months; months without hours show an
/// empty bar so the current month always sits at the same place.
class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key, required this.monthlyHours});

  final List<MonthlyHoursEntity> monthlyHours;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(
      3,
      (i) => DateTime(now.year, now.month - 2 + i),
    );
    final hours = months.map((m) {
      final match = monthlyHours.where(
        (e) => e.year == m.year && e.month == m.month,
      );
      return match.isEmpty ? 0.0 : match.first.hours;
    }).toList();
    final maxHours = hours.reduce((a, b) => a > b ? a : b);
    final isEmpty = maxHours <= 0;

    return Container(
      width: double.infinity,
      // Not below 220 design px: .h shrinks on short screens but the .sp
      // title/labels inside don't, which squeezed the bars into overflow.
      height: math.max(220, 220.h),
      padding: EdgeInsets.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ساعات التطوع الشهرية', style: AppText.title()),
          SizedBox(height: Space.vm),
          Expanded(
            child: isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          AppIcons.hours,
                          size: AppSizes.iconL + 8,
                          color: ColorManager.inkFaint,
                        ),
                        SizedBox(height: Space.vs),
                        Text(
                          'لا توجد ساعات مسجلة في آخر 3 أشهر',
                          style: AppText.label(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : AfterTransition(
                    placeholder: const SizedBox.shrink(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var i = 0; i < months.length; i++)
                          Expanded(
                            child: BarColumn(
                              label: DateAr.month(months[i].month),
                              hours: hours[i],
                              ratio: hours[i] / maxHours,
                              highlighted: i == months.length - 1,
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
