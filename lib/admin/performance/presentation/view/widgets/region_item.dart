import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// One ranked region. Rank #1 is the only one that earns the star.
class RegionItem extends StatelessWidget {
  const RegionItem({
    super.key,
    required this.rank,
    required this.region,
    required this.count,
    required this.fraction,
  });

  final int rank;
  final String region;
  final int count;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final isTop = rank == 1;
    const badge = 28.0;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: Space.vm),
      child: Row(
        children: [
          Container(
            width: badge,
            height: badge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTop ? ColorManager.starSoft : ColorManager.surfaceSunken,
            ),
            child: isTop
                ? Icon(AppIcons.star, size: AppSizes.iconS, color: ColorManager.star)
                : Text(
                    '$rank',
                    style: getNumericStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.inkMuted,
                    ),
                  ),
          ),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        region,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label(
                          color: isTop ? ColorManager.starText : ColorManager.ink,
                        ),
                      ),
                    ),
                    Text(
                      '$count متطوع',
                      style: getNumericStyle(
                        fontSize: FontSize.s12,
                        color: ColorManager.inkMuted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Space.vxs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.small),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: fraction.clamp(0.0, 1.0)),
                    duration: AppMotion.of(context, AppMotion.slow),
                    curve: AppMotion.enter,
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 6,
                      backgroundColor: ColorManager.brandSoft,
                      color: ColorManager.brand,
                    ),
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
