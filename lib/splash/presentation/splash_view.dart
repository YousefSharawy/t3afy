import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/translation/locale_keys.g.dart';
import '../cubit/splash_cubit.dart';

/// "From the roots, together" — the logo's own story told once:
/// first light rises on Deep Root, a sprout line climbs from the bottom edge,
/// the (unchanged) logo arrives where it ends, its star glints gold once, and
/// the name settles in. ~1.6 s, transform/opacity + one stroked path only.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(
        duration: const Duration(milliseconds: 1600),
        vsync: this,
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _introDone = true;
          _maybeNavigate();
        }
      });

  // Beats (fractions of 1.6 s).
  late final Animation<double> _light = _interval(0.00, 0.45, Curves.easeOut);
  late final Animation<double> _stem = _interval(
    0.05,
    0.50,
    Curves.easeInOutCubic,
  );
  late final Animation<double> _logo = _interval(
    0.38,
    0.68,
    Curves.easeOutBack,
  );
  late final Animation<double> _glint = _interval(0.62, 0.92, Curves.easeOut);
  late final Animation<double> _name = _interval(
    0.66,
    0.96,
    Curves.easeOutCubic,
  );

  Animation<double> _interval(double a, double b, Curve c) => CurvedAnimation(
    parent: _controller,
    curve: Interval(a, b, curve: c),
  );

  // Navigate only when both the intro and the start-route checks are done.
  String? _route;
  bool _introDone = false;

  @override
  void initState() {
    super.initState();
    // Started after the first frame so the BlocListener is subscribed before
    // the cubit can emit.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashCubit>().start();
      if (AppMotion.reduced(context)) {
        _controller.value = 1.0;
        _introDone = true;
        _maybeNavigate();
      } else {
        _controller.forward();
      }
    });
  }

  void _maybeNavigate() {
    final route = _route;
    if (route == null || !_introDone || !mounted) return;
    context.go(route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (route) {
              _route = route;
              _maybeNavigate();
            },
          );
        },
        child: Scaffold(
          backgroundColor: ColorManager.ink,
          body: LayoutBuilder(
            builder: (context, box) {
              final logoSize = 168.w;
              final center = Offset(box.maxWidth / 2, box.maxHeight * 0.44);
              return Stack(
                children: [
                  // First light + sprout stem (one painter, repaints alone).
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: _RootsPainter(
                          light: _light,
                          stem: _stem,
                          target: center + Offset(0, logoSize / 2),
                        ),
                      ),
                    ),
                  ),
                  // The logo, unchanged — only scale/opacity around it.
                  Positioned(
                    left: center.dx - logoSize / 2,
                    top: center.dy - logoSize / 2,
                    width: logoSize,
                    height: logoSize,
                    child: FadeTransition(
                      opacity: _logo.drive(
                        Tween(
                          begin: 0.0,
                          end: 1.0,
                        ).chain(CurveTween(curve: const Interval(0, 0.6))),
                      ),
                      child: ScaleTransition(
                        scale: _logo.drive(Tween(begin: 0.82, end: 1.0)),
                        child: Image.asset(
                          IconAssets.logo,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ),
                  ),
                  // One gold glint on the logo's own star (asset coords ≈ 65%, 16%).
                  Positioned(
                    left: center.dx - logoSize / 2 + logoSize * 0.645 - 28,
                    top: center.dy - logoSize / 2 + logoSize * 0.163 - 28,
                    width: 56,
                    height: 56,
                    child: IgnorePointer(
                      child: CustomPaint(painter: _GlintPainter(_glint)),
                    ),
                  ),
                  // Name + line, rising into place.
                  Positioned(
                    left: Space.gutter,
                    right: Space.gutter,
                    top: center.dy + logoSize / 2 + Space.vxl,
                    child: FadeTransition(
                      opacity: _name,
                      child: SlideTransition(
                        position: _name.drive(
                          Tween(begin: const Offset(0, 0.25), end: Offset.zero),
                        ),
                        child: Column(
                          children: [
                            Text(
                              LocaleKeys.app_name.tr(),
                              textAlign: TextAlign.center,
                              style: getDisplayStyle(
                                fontSize: FontSize.s28,
                                color: ColorManager.onInk,
                              ),
                            ),
                            SizedBox(height: Space.vs),
                            Container(
                              width: 32.w,
                              height: 3,
                              decoration: BoxDecoration(
                                color: ColorManager.sprout,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Teal "first light" rising from the bottom + a sprout-green stem that grows
/// from the bottom edge up to the logo, with two short root strokes.
class _RootsPainter extends CustomPainter {
  _RootsPainter({required this.light, required this.stem, required this.target})
    : super(repaint: Listenable.merge([light, stem]));

  final Animation<double> light;
  final Animation<double> stem;
  final Offset target;

  @override
  void paint(Canvas canvas, Size size) {
    // First light: radial glow anchored below the screen, rising with t.
    final l = light.value;
    if (l > 0) {
      final glowCenter = Offset(
        size.width / 2,
        size.height * (1.15 - 0.25 * l),
      );
      final radius = size.height * (0.45 + 0.25 * l);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            ColorManager.brand.withValues(alpha: 0.55 * l),
            ColorManager.brand.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: glowCenter, radius: radius));
      canvas.drawCircle(glowCenter, radius, paint);
    }

    // Stem: a gentle S-curve from the bottom edge to just under the logo.
    final s = stem.value;
    if (s <= 0) return;
    final start = Offset(size.width / 2, size.height + 4);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx - 26,
        start.dy - (start.dy - target.dy) * 0.35,
        target.dx + 22,
        target.dy + (start.dy - target.dy) * 0.35,
        target.dx,
        target.dy,
      );
    final metric = path.computeMetrics().first;
    final drawn = metric.extractPath(0, metric.length * s);
    // Fades out as the logo takes over, so it never competes with it.
    final fade = s < 1 ? 1.0 : (1.0 - (light.value - 0.0)).clamp(0.35, 1.0);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4
      ..color = ColorManager.sprout.withValues(alpha: 0.9 * fade);
    canvas.drawPath(drawn, stroke);

    // Two short roots at the base, drawn in the first fifth of the stem.
    final r = (s / 0.2).clamp(0.0, 1.0);
    if (r > 0) {
      final root = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.6
        ..color = ColorManager.sprout.withValues(alpha: 0.5 * r);
      final base = Offset(start.dx, size.height - 10);
      canvas.drawLine(base, base + Offset(-18 * r, 10 * r), root);
      canvas.drawLine(base, base + Offset(16 * r, 12 * r), root);
    }
  }

  @override
  bool shouldRepaint(_RootsPainter old) => old.target != target;
}

/// A single four-point gold glint that blooms and fades once.
class _GlintPainter extends CustomPainter {
  _GlintPainter(this.t) : super(repaint: t);
  final Animation<double> t;

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    if (v <= 0 || v >= 1) return;
    // Up then down: peak at 40% of the beat.
    final a = v < 0.4 ? v / 0.4 : 1 - (v - 0.4) / 0.6;
    final c = size.center(Offset.zero);
    final len = size.width / 2 * (0.5 + 0.5 * a);
    final paint = Paint()
      ..color = ColorManager.star.withValues(alpha: a)
      ..style = PaintingStyle.fill;
    final w = len * 0.16;
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final ang = i * math.pi / 2;
      final tip = c + Offset(math.cos(ang), math.sin(ang)) * len;
      final l =
          c +
          Offset(math.cos(ang + math.pi / 2), math.sin(ang + math.pi / 2)) * w;
      final r =
          c +
          Offset(math.cos(ang - math.pi / 2), math.sin(ang - math.pi / 2)) * w;
      path
        ..moveTo(l.dx, l.dy)
        ..lineTo(tip.dx, tip.dy)
        ..lineTo(r.dx, r.dy)
        ..close();
    }
    canvas.drawPath(path, paint);
    canvas.drawCircle(
      c,
      w * 1.6,
      Paint()..color = ColorManager.white.withValues(alpha: a * 0.9),
    );
  }

  @override
  bool shouldRepaint(_GlintPainter old) => false;
}
