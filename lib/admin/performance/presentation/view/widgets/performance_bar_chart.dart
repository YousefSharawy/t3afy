import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/after_transition.dart';

/// Completed tasks per bucket; the last (current) bucket is highlighted.
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
    final isEmpty = bars.isEmpty || bars.every((b) => b.count == 0);
    final pct = _percentageChange;
    final up = pct >= 0;
    final flat = pct == 0;
    final trendColor = flat
        ? ColorManager.inkFaint
        : up
        ? ColorManager.sproutText
        : ColorManager.error;

    return Container(
      padding: EdgeInsetsDirectional.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppText.bodyStrong())),
              if (!isEmpty)
                Semantics(
                  label: up
                      ? 'زيادة $pct٪ عن الفترة السابقة'
                      : 'انخفاض ${pct.abs()}٪ عن الفترة السابقة',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trend arrows must not mirror in RTL (up stays up).
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Icon(
                          flat
                              ? AppIcons.trendFlat
                              : up
                              ? AppIcons.trendUp
                              : AppIcons.trendDown,
                          size: AppSizes.iconS,
                          color: trendColor,
                        ),
                      ),
                      SizedBox(width: Space.xxs),
                      Text(
                        '${pct.abs()}%',
                        style: getNumericStyle(
                          fontSize: FontSize.s13,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: Space.vm),
          if (isEmpty)
            const AppEmptyState(
              title: 'لا توجد مهام منجزة في هذه الفترة',
              icon: AppIcons.performance,
              compact: true,
            )
          else
            SizedBox(
              height: 160.h,
              child: AfterTransition(
                placeholder: const SizedBox.shrink(),
                child: _chart(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chart() {
    final maxY = bars
        .map((e) => e.count)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final lastIndex = bars.length - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = bars.length;
        final minSlot = 52.w;
        final chartWidth = count * minSlot > constraints.maxWidth
            ? count * minSlot
            : constraints.maxWidth;
        final barWidth = (chartWidth / count * 0.55).clamp(12.w, 36.w);
        // Axis labels are caption text (sp × system text scale); a fixed .h
        // reserve is too short on squat screens at large text sizes.
        final labelReserve =
            Space.vxs +
            MediaQuery.textScalerOf(context).scale(FontSize.s11) * 1.8;
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
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: ColorManager.line, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => ColorManager.ink,
                    tooltipRoundedRadius: Radii.small,
                    tooltipPadding: EdgeInsets.symmetric(
                      horizontal: Space.s,
                      vertical: Space.vxs,
                    ),
                    tooltipMargin: Space.vs,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final idx = group.x;
                      if (idx < 0 || idx >= bars.length) return null;
                      final bar = bars[idx];
                      return BarTooltipItem(
                        '${bar.label}\n',
                        getMediumStyle(
                          fontSize: FontSize.s11,
                          color: ColorManager.onInkMuted,
                        ),
                        children: [
                          TextSpan(
                            text: '${bar.count} مهمة',
                            style: getNumericStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.onInk,
                            ),
                          ),
                        ],
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
                      reservedSize: labelReserve < 28.h ? 28.h : labelReserve,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= bars.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsetsDirectional.only(top: Space.vxs),
                          child: Text(
                            bars[idx].label,
                            style: AppText.caption(
                              color: idx == lastIndex
                                  ? ColorManager.ink
                                  : ColorManager.inkFaint,
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
                        color: i == lastIndex
                            ? ColorManager.brand
                            : ColorManager.brandSoft,
                        width: barWidth,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Radii.small),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
