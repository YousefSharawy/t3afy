import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// One month bar; its height scales to the space the chart card gives it.
class BarColumn extends StatelessWidget {
  const BarColumn({
    super.key,
    required this.label,
    required this.hours,
    required this.ratio,
    this.highlighted = false,
  });

  final String label;
  final double hours;
  final double ratio;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final value = hours == hours.roundToDouble()
        ? hours.toInt().toString()
        : hours.toStringAsFixed(1);
    return Semantics(
      label: '$label: $value ساعة',
      child: ExcludeSemantics(
        child: Column(
          children: [
            Text(
              value,
              style: getNumericStyle(
                fontSize: FontSize.s13,
                color: highlighted
                    ? ColorManager.brandStrong
                    : ColorManager.inkMuted,
              ),
            ),
            SizedBox(height: Space.vxs),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final h = (c.maxHeight * ratio.clamp(0.0, 1.0)).clamp(
                    4.0,
                    c.maxHeight,
                  );
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: h),
                      duration: AppMotion.of(context, AppMotion.slow),
                      curve: AppMotion.enter,
                      builder: (context, animated, _) => Container(
                        width: Space.xxl + Space.s,
                        height: animated,
                        decoration: BoxDecoration(
                          color: highlighted
                              ? ColorManager.brand
                              : ColorManager.primary200,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Radii.small),
                            bottom: const Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Space.vs),
            Text(
              label,
              style: highlighted
                  ? AppText.label(color: ColorManager.ink)
                  : AppText.label(color: ColorManager.inkFaint),
            ),
          ],
        ),
      ),
    );
  }
}
