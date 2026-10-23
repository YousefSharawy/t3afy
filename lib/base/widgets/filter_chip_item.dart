import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';

/// Filter chip. Selected = solid brand, unselected = surface with a hairline.
/// (The old version painted both states with the same background.)
class FilterChipItem extends StatelessWidget {
  const FilterChipItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
    this.selectedColor = ColorManager.brand,
    this.unselectedColor = ColorManager.surface,
    this.borderRadius,
    this.horizontalPadding,
    this.border,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;
  final Color selectedColor;
  final Color unselectedColor;
  final double? borderRadius;
  final double? horizontalPadding;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? ColorManager.white : ColorManager.inkMuted;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppMotion.of(context),
          curve: AppMotion.enter,
          constraints: BoxConstraints(minHeight: AppHeight.s36),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? Space.m,
          ),
          decoration: BoxDecoration(
            color: selected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(borderRadius ?? Radii.chip),
            border:
                border ??
                Border.all(color: selected ? selectedColor : ColorManager.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: selected
                    ? getSemiBoldStyle(fontSize: FontSize.s13, color: fg)
                    : getMediumStyle(fontSize: FontSize.s13, color: fg),
              ),
              if (count != null) ...[
                SizedBox(width: Space.xs),
                Text(
                  '$count',
                  style: getNumericStyle(
                    fontSize: FontSize.s12,
                    color: selected
                        ? ColorManager.white.withValues(alpha: 0.85)
                        : ColorManager.inkFaint,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
