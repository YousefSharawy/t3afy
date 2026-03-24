import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PerformanceBarChart extends StatelessWidget {
  const PerformanceBarChart({
    super.key,
    required this.bars,
    required this.title,
  });

  final List<PerformanceBarEntry> bars;
  final String title;

  int get _percentageChange {
    if (bars.length < 2) return 0;
    final current = bars.last.count;
    final previous = bars[bars.length - 2].count;
    if (previous == 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) return const SizedBox.shrink();

    final maxY = bars
        .map((e) => e.count)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final pct = _percentageChange;

    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorManager.natural50,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(
          color: ColorManager.primary500.withValues(alpha: 0.1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.natural600,
                ),
              ),
              Text(
                pct >= 0 ? '$pct% ↑' : '${pct.abs()}% ↓',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: pct >= 0 ? ColorManager.success : ColorManager.error,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s13),
          SizedBox(
            height: AppHeight.s140,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final count = bars.length;
                final minWidth = count * AppWidth.s64;
                final chartWidth = minWidth > constraints.maxWidth
                    ? minWidth
                    : constraints.maxWidth;
                final barWidth = (chartWidth / count).clamp(
                  AppWidth.s64,
                  AppWidth.s81,
                );
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: BarChart(
                      BarChartData(
                        maxY: maxY == 0 ? 1 : maxY * 1.2,
                        backgroundColor: Colors.transparent,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: ColorManager.primary500.withValues(alpha: 0.06),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => ColorManager.natural50,
                            tooltipRoundedRadius: AppRadius.s8,
                            tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            tooltipMargin: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final idx = group.x;
                              if (idx < 0 || idx >= bars.length) return null;
                              final bar = bars[idx];
                              return BarTooltipItem(
                                '${bar.label}: ${bar.count} مهام',
                                getMediumStyle(
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontSize.s12,
                                  color: ColorManager.natural900,
                                ),
                              );
                            },
                          ),
                        ),
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
                                if (idx < 0 || idx >= bars.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    bars[idx].label,
                                    style: getLightStyle(
                                      fontFamily: FontConstants.fontFamily,
                                      fontSize: FontSize.s12,
                                      color: ColorManager.natural900,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(bars.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: bars[i].count.toDouble(),
                                color: ColorManager.primary500,
                                width: barWidth,
                                borderRadius: BorderRadius.circular(AppRadius.s16),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
