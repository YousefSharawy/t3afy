import 'package:t3afy/app/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// One KPI tile for both roles. Big number in the display face.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.tint = ColorManager.brand,
    this.trend,
    this.trendUp,
    this.centered = false,
    this.onDark = false,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color tint;

  /// Optional small delta text, e.g. "+12%".
  final String? trend;
  final bool? trendUp;
  final bool centered;

  /// Render on the Deep Root command band (Manager home).
  final bool onDark;
  final VoidCallback? onTap;

  Color get _trendColor => trendUp == null
      ? (onDark ? ColorManager.onInkMuted : ColorManager.inkFaint)
      : trendUp!
      ? ColorManager.sprout
      : ColorManager.error;

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? ColorManager.onInk : ColorManager.ink;
    final sub = onDark ? ColorManager.onInkMuted : ColorManager.inkMuted;
    final align = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    final content = Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            padding: EdgeInsets.all(Space.xs + 2),
            decoration: BoxDecoration(
              color: onDark
                  ? ColorManager.white.withValues(alpha: 0.08)
                  : tint.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(Radii.small),
            ),
            child: Icon(
              icon,
              size: AppSizes.iconM,
              color: onDark ? ColorManager.onInk : tint,
            ),
          ),
          SizedBox(height: Space.vs),
        ],
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: getDisplayStyle(fontSize: FontSize.s22, color: fg),
          ),
        ),
        SizedBox(height: Space.vxs * 0.5),
        Text(
          label,
          style: getMediumStyle(fontSize: FontSize.s12, color: sub),
          textAlign: centered ? TextAlign.center : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (trend != null) ...[
          SizedBox(height: Space.vxs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trend arrows must not mirror in RTL (up stays up).
              Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  trendUp == null
                      ? AppIcons.trendFlat
                      : trendUp!
                      ? AppIcons.trendUp
                      : AppIcons.trendDown,
                  size: 14,
                  color: _trendColor,
                ),
              ),
              SizedBox(width: Space.xxs),
              Text(
                trend!,
                style: getNumericStyle(
                  fontSize: FontSize.s11,
                  color: _trendColor,
                ),
              ),
            ],
          ),
        ],
      ],
    );

    final box = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Space.m, vertical: Space.vm),
      decoration: BoxDecoration(
        color: onDark
            ? ColorManager.white.withValues(alpha: 0.06)
            : ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: onDark
            ? Border.all(color: ColorManager.white.withValues(alpha: 0.08))
            : null,
      ),
      child: content,
    );

    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.card),
        child: box,
      ),
    );
  }
}
