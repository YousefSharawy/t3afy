import 'package:t3afy/app/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';

class CampaignCompletionCard extends StatelessWidget {
  const CampaignCompletionCard({
    super.key,
    required this.data,
    required this.selectedPeriod,
  });

  final AdminPerformanceEntity data;
  final String selectedPeriod;

  /// The datasource uses rolling windows, not calendar periods.
  static String periodLabel(String period) => switch (period) {
    'week' => 'آخر 7 أيام',
    'months' => 'آخر 30 يومًا',
    _ => 'آخر 12 شهرًا',
  };

  @override
  Widget build(BuildContext context) {
    final pct = data.campaignCompletionPercent;
    final change = data.completionPercentChange;
    final isPositive = change >= 0;
    final fg = isPositive ? ColorManager.sproutText : ColorManager.error;

    return Container(
      padding: EdgeInsetsDirectional.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Row(
        children: [
          StarBloomProgress(value: pct / 100, size: 80, stroke: 8),
          SizedBox(width: Space.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('معدل إنجاز الحملات', style: AppText.bodyStrong()),
                SizedBox(height: Space.vxs),
                Text(
                  '${data.completedCampaigns} حملة مكتملة من ${data.totalCampaigns} مجدولة · ${periodLabel(selectedPeriod)}',
                  style: AppText.label(),
                ),
                SizedBox(height: Space.vm),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: Space.vxs,
                    horizontal: Space.s,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? ColorManager.sproutSoft
                        : ColorManager.errorLight,
                    borderRadius: BorderRadius.circular(Radii.small),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? AppIcons.trendUp
                            : AppIcons.trendDown,
                        size: AppSizes.iconS,
                        color: fg,
                      ),
                      SizedBox(width: Space.xxs),
                      Flexible(
                        child: Text(
                          '${change.abs().toStringAsFixed(1)}% عن الفترة السابقة',
                          style: getNumericStyle(
                            fontSize: FontSize.s11,
                            color: fg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
