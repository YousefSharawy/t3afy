import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Signature progress ring — "rising toward the star".
///
/// The arc grows in sprout green; when [value] reaches 1.0 the center blooms
/// once into the gold star (scale + fade, ~600 ms), then rests. It never loops.
/// Under reduced motion the end state is shown immediately.
class StarBloomProgress extends StatefulWidget {
  const StarBloomProgress({
    super.key,
    required this.value,
    this.size = 56,
    this.stroke = 5,
    this.label,
    this.color = ColorManager.sprout,
    this.trackColor = ColorManager.natural100,
  });

  /// 0.0 – 1.0
  final double value;
  final double size;
  final double stroke;

  /// Center text when not complete (defaults to the percentage).
  final String? label;
  final Color color;
  final Color trackColor;

  @override
  State<StarBloomProgress> createState() => _StarBloomProgressState();
}

class _StarBloomProgressState extends State<StarBloomProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bloom = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  bool get _complete => widget.value >= 0.999;

  @override
  void initState() {
    super.initState();
    if (_complete) _bloom.value = 1;
  }

  @override
  void didUpdateWidget(StarBloomProgress old) {
    super.didUpdateWidget(old);
    final wasComplete = old.value >= 0.999;
    if (_complete && !wasComplete) {
      if (AppMotion.reduced(context)) {
        _bloom.value = 1;
      } else {
        _bloom.forward(from: 0);
      }
    } else if (!_complete) {
      _bloom.value = 0;
    }
  }

  @override
  void dispose() {
    _bloom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.value.clamp(0.0, 1.0);
    return Semantics(
      label: _complete ? 'مكتمل' : '${(v * 100).round()}٪',
      child: SizedBox.square(
        dimension: widget.size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: v),
          duration: AppMotion.of(context, AppMotion.slow),
          curve: AppMotion.enter,
          builder: (context, animated, _) {
            return CustomPaint(
              painter: _RingPainter(
                value: animated,
                stroke: widget.stroke,
                color: _complete ? ColorManager.star : widget.color,
                track: widget.trackColor,
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _bloom,
                  builder: (context, _) {
                    final t = Curves.easeOutBack.transform(_bloom.value);
                    if (_bloom.value == 0) {
                      // Scales down inside the ring instead of spilling out
                      // (long labels / large text scale).
                      return Padding(
                        padding: EdgeInsets.all(widget.stroke + 2),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.label ?? '${(v * 100).round()}%',
                            maxLines: 1,
                            style: getNumericStyle(
                              fontSize: widget.size * 0.24,
                              color: ColorManager.ink,
                            ),
                          ),
                        ),
                      );
                    }
                    return Opacity(
                      opacity: _bloom.value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.4 + 0.6 * t,
                        child: Icon(
                          AppIcons.star,
                          color: ColorManager.star,
                          size: widget.size * 0.52,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.stroke,
    required this.color,
    required this.track,
  });

  final double value;
  final double stroke;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r, 0, math.pi * 2, false, base..color = track);
    if (value <= 0) return;
    // Starts at the bottom (the roots) and rises.
    canvas.drawArc(
      r,
      math.pi / 2,
      math.pi * 2 * value,
      false,
      base..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Linear variant for card rows ("12 / 20 متطوع").
class StarBloomBar extends StatelessWidget {
  const StarBloomBar({super.key, required this.value, this.height = 6});
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    final complete = v >= 0.999;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: v),
              duration: AppMotion.of(context, AppMotion.slow),
              curve: AppMotion.enter,
              builder: (_, a, _) => LinearProgressIndicator(
                value: a,
                minHeight: height,
                backgroundColor: ColorManager.natural100,
                color: complete ? ColorManager.star : ColorManager.sprout,
              ),
            ),
          ),
        ),
        if (complete) ...[
          SizedBox(width: Space.xs),
          Icon(AppIcons.star, size: height * 2.6, color: ColorManager.star),
        ],
      ],
    );
  }
}
