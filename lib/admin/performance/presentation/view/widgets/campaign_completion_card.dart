import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class CampaignCompletionCard extends StatelessWidget {
  const CampaignCompletionCard({
    super.key,
    required this.data,
    required this.selectedPeriod,
  });

  final AdminPerformanceEntity data;
  final String selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final pct = data.campaignCompletionPercent;
    final change = data.completionPercentChange;
    final isPositive = change >= 0;

    final periodLabel = switch (selectedPeriod) {
      'week' => 'هذا الأسبوع',
      'months' => 'هذا الشهر',
      _ => 'هذا العام',
    };

    final comparisonLabel = switch (selectedPeriod) {
      'week' => 'عن الأسبوع الماضي',
      'months' => 'عن الشهر الماضي',
      _ => 'عن العام الماضي',
    };

    return Container(
      padding: EdgeInsets.all(AppWidth.s12),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppWidth.s80,
            height: AppWidth.s80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(AppWidth.s80, AppWidth.s80),
                  painter: _CircularRingPainter(
                    progress: (pct / 100).clamp(0.0, 1.0),
                  ),
                ),
                Text(
                  '${pct.round()}%',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s18,
                    color: ColorManager.primary500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppWidth.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معدل إنجاز الحملات',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: ColorManager.natural600,
                  ),
                ),
                Text(
                  '${data.completedCampaigns} حملة مكتملة من ${data.totalCampaigns} مجدولة $periodLabel',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.natural400,
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppHeight.s4,
                    horizontal: AppWidth.s8,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? ColorManager.infoLight : ColorManager.errorLight,
                    borderRadius: BorderRadius.circular(AppRadius.s8)
                  ),
                  child: Text(
                    isPositive
                        ? '↑ ${change.abs().toStringAsFixed(1)}% $comparisonLabel'
                        : '↓ ${change.abs().toStringAsFixed(1)}% $comparisonLabel',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: isPositive
                          ? ColorManager.info
                          : ColorManager.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppWidth.s16),
        ],
      ),
    );
  }
}

class _CircularRingPainter extends CustomPainter {
  final double progress;
  _CircularRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 9.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track
    final trackPaint = Paint()
      ..color = ColorManager.primary500.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Gradient progress arc
    if (progress > 0) {
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: const [ColorManager.primary300, ColorManager.primary500],
        stops: const [0.0, 1.0],
      );

      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = gradient.createShader(rect);

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularRingPainter old) =>
      old.progress != progress;
}
