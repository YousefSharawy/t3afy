import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

/// Hero of the performance tab — overall rating in star gold and the
/// commitment ratio as the star-bloom ring ("rising toward the star").
class RatingCard extends StatelessWidget {
  const RatingCard({super.key, required this.stats});

  final PerformanceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final filled = stats.rating.round().clamp(0, 5);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تقييمي الكلي', style: AppText.label()),
                SizedBox(height: Space.vxs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      stats.rating.toStringAsFixed(1),
                      style: AppText.display(),
                    ),
                    SizedBox(width: Space.xs),
                    Text(
                      '/ 5.0',
                      style: getNumericStyle(
                        fontSize: FontSize.s13,
                        color: ColorManager.inkFaint,
                        fontWeight: FontWeightManager.medium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Space.vxs),
                Semantics(
                  label: 'التقييم ${stats.rating.toStringAsFixed(1)} من 5',
                  child: ExcludeSemantics(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < filled ? AppIcons.star : AppIcons.unstar,
                          size: AppSizes.iconL,
                          color: i < filled
                              ? ColorManager.star
                              : ColorManager.line,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Space.vm),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: Space.m,
                    vertical: Space.vxs,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.brandSoft,
                    borderRadius: BorderRadius.circular(Radii.chip),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.promotion,
                        size: AppSizes.iconS,
                        color: ColorManager.brandStrong,
                      ),
                      SizedBox(width: Space.xs),
                      Flexible(
                        child: Text(
                          stats.levelTitle,
                          style: AppText.label(color: ColorManager.brandStrong),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Space.m),
          Column(
            children: [
              StarBloomProgress(
                value: stats.commitmentPct / 100,
                size: 84,
                stroke: 7,
              ),
              SizedBox(height: Space.vs),
              Text('الالتزام', style: AppText.label()),
            ],
          ),
        ],
      ),
    );
  }
}
