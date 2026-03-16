import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class MonthlyChartWidget extends StatelessWidget {
  const MonthlyChartWidget({super.key, required this.data});

  final List<MonthlyTaskCount> data;

  static const _arabicMonths = [
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

  int get _percentageChange {
    if (data.length < 2) return 0;
    final current = data.last.count;
    final previous = data[data.length - 2].count;
    if (previous == 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxY = data.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble();
    final pct = _percentageChange;

    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0C203B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A5F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row (RTL: title on right, badge on left)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'المهام المنجزة شهرياً',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s10,
                  vertical: AppHeight.s4,
                ),
                decoration: BoxDecoration(
                  color: pct >= 0
                      ? const Color(0xFF14532D)
                      : const Color(0xFF450A0A),
                  borderRadius: BorderRadius.circular(AppRadius.s20),
                ),
                child: Text(
                  pct >= 0 ? '$pct% ↑' : '${pct.abs()}% ↓',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: pct >= 0
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
              // Title
             
            ],
          ),
          SizedBox(height: AppHeight.s20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: maxY == 0 ? 1 : maxY * 1.2,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        final monthIndex = data[idx].month.month - 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _arabicMonths[monthIndex],
                            style: getRegularStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s9,
                              color: Colors.white54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].count.toDouble(),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF00BCD4)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
