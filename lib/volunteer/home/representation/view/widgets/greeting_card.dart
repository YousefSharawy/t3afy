import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// The "rising together" moment at the top of Home: Deep Root band with the
/// volunteer's name and level.
class GreetingCard extends StatelessWidget {
  const GreetingCard({
    super.key,
    required this.name,
    required this.level,
    required this.levelTitle,
  });

  final String name;
  final int level;
  final String levelTitle;

  String get _greeting =>
      DateTime.now().hour < 12 ? 'صباح الخير' : 'مساء الخير';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        Space.l,
        Space.vl,
        Space.l,
        Space.vl,
      ),
      decoration: BoxDecoration(
        color: ColorManager.ink,
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: getMediumStyle(
                    fontSize: FontSize.s13,
                    color: ColorManager.onInkMuted,
                  ),
                ),
                SizedBox(height: Space.vxs),
                Text(
                  name,
                  style: getDisplayStyle(
                    fontSize: FontSize.s22,
                    color: ColorManager.onInk,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Space.vm),
                _Pill(
                  icon: AppIcons.medal,
                  text: '$levelTitle · المستوى $level',
                ),
              ],
            ),
          ),
          SizedBox(width: Space.m),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ColorManager.brand.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              AppIcons.vol,
              color: ColorManager.onInk,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Space.s + 2, vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Radii.chip),
        border: Border.all(color: ColorManager.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorManager.onInkMuted),
          SizedBox(width: Space.xs),
          Flexible(
            child: Text(
              text,
              style: getMediumStyle(
                fontSize: FontSize.s12,
                color: ColorManager.onInk,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
