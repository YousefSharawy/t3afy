import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class CampaignCompletionCard extends StatelessWidget {
  const CampaignCompletionCard({super.key, required this.data});

  final AdminPerformanceEntity data;

  @override
  Widget build(BuildContext context) {
    final pct = data.campaignCompletionPercent;
    final change = data.completionPercentChange;
    final isPositive = change >= 0;

    return Container(
      width: AppWidth.s339,
      height: AppHeight.s111,
      padding: EdgeInsets.all(AppWidth.s12),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: .center,
            children: [
              SizedBox(
                width: AppWidth.s69,
                height: AppHeight.s69,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(AppWidth.s100, AppHeight.s100),
                      painter: _CircularGradientPainter(
                        progress: (pct / 100).clamp(0.0, 1.0),
                      ),
                    ),
                    Text(
                      '${pct.round()}%',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(width: AppWidth.s16),
          Column(mainAxisAlignment: .start,
          crossAxisAlignment:.start ,
            children: [
              Text(
                'معدل إنجاز الحملات',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s17,
                  color: ColorManager.white,
                ),
              ),
              Text(
                '${data.completedCampaigns} حملة مكتملة من ${data.totalCampaigns} مجدولة',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.blueOne100,
                ),
              ),
              SizedBox(height: AppHeight.s6),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s8,
                  vertical: AppHeight.s2,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF1E6DE5)
                      : const Color(0xFF450A0A),
                  borderRadius: BorderRadius.circular(AppRadius.s6),
                ),
                child: Text(
                  isPositive
                      ? '↑ ${change.abs().round()}% عن الشهر الماضي'
                      : '↓ ${change.abs().round()}% عن الشهر الماضي',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: isPositive
                        ? ColorManager.blueThree300
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularGradientPainter extends CustomPainter {
  final double progress;
  _CircularGradientPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height).deflate(6);
    const strokeWidth = 8.0;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 3.1415926 * 2, false, trackPaint);

    // Gradient arc
    if (progress > 0) {
      final sweepAngle = 3.1415926 * 2 * progress;
      final gradient = SweepGradient(
        startAngle: -3.1415926 / 2,
        endAngle: -3.1415926 / 2 + sweepAngle,
        colors: const [ Color(0xFF2764E7),Color(0xFF36DFF1),],
        stops: const [0.0, 1.0],
      );
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = gradient.createShader(rect);
      canvas.drawArc(rect, -3.1415926 / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircularGradientPainter old) =>
      old.progress != progress;
}
