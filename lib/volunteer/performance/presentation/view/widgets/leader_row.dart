import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

class LeaderRow extends StatelessWidget {
  const LeaderRow({
    super.key,
    required this.rank,
    required this.name,
    required this.hours,
    required this.pts,
    required this.isMe,
  });

  final int rank;
  final String name;
  final int hours;
  final int pts;
  final bool isMe;

  /// Gold is earned by #1 only; #2/#3 get neutral silver/bronze-like tones.
  (Color bg, Color fg) get _medal => switch (rank) {
    1 => (ColorManager.starSoft, ColorManager.star),
    2 => (ColorManager.natural100, ColorManager.natural700),
    3 => (ColorManager.line, ColorManager.natural600),
    _ => (ColorManager.surfaceSunken, ColorManager.inkFaint),
  };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _medal;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: AppSizes.touch + Space.vm),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Space.m,
        vertical: Space.vm,
      ),
      decoration: BoxDecoration(
        color: isMe ? ColorManager.brandSoft : ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(
          color: isMe ? ColorManager.brand : ColorManager.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: rank == 1
                ? Icon(
                    AppIcons.star,
                    size: 26,
                    color: fg,
                    semanticLabel: 'المركز الأول',
                  )
                : Text(
                    '$rank',
                    style: getNumericStyle(
                      fontSize: FontSize.s16,
                      color: fg,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
          ),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppText.bodyStrong(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('$hours ساعة', style: AppText.caption()),
              ],
            ),
          ),
          SizedBox(width: Space.s),
          Text(
            '$pts نقطة',
            style: getNumericStyle(
              fontSize: FontSize.s15,
              color: rank == 1 ? ColorManager.starText : ColorManager.ink,
              fontWeight: FontWeightManager.bold,
            ),
          ),
        ],
      ),
    );
  }
}
