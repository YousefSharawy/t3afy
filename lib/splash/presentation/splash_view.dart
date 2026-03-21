import 'dart:math';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/translation/locale_keys.g.dart';
import '../cubit/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Phase 1: Circular reveal
  late Animation<double> _circleReveal;
  // Phase 2: Logo + text fade in at center
  late Animation<double> _centerFadeIn;
  // Phase 3: Arc split — logo goes left (CCW), text goes right (CW)
  late Animation<double> _arcSplit;

  bool _hasCompletedOnboarding = false;

  static final String _splashText = LocaleKeys.app_name.tr();

  @override
  void initState() {
    super.initState();
    // _hasCompletedOnboarding = LocalAppStorage.isOnboardingCompleted();
    context.read<SplashCubit>().start();

    if (_hasCompletedOnboarding) {
      // ── Returning user: same 3 phases but faster ──────────────
      _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );

      // Circle reveal (0% – 30%)
      _circleReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.30, curve: Curves.easeInOut),
        ),
      );

      // Center fade in (25% – 50%)
      _centerFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.25, 0.50, curve: Curves.easeIn),
        ),
      );

      // Arc split (50% – 85%)
      _arcSplit = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.50, 0.85, curve: Curves.easeInOutCubic),
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    } else {
      // ── First-time user: full duration ────────────────────────
      _controller = AnimationController(
        duration: const Duration(milliseconds: 3200),
        vsync: this,
      );

      // Circle reveal (0% – 20%)
      _circleReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.20, curve: Curves.easeInOut),
        ),
      );

      // Center fade in (18% – 38%)
      _centerFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.18, 0.38, curve: Curves.easeIn),
        ),
      );

      // Arc split (42% – 72%)
      _arcSplit = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.42, 0.72, curve: Curves.easeInOutCubic),
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        state.when(initial: () {}, success: (view) => context.go(view));
      },
      child: PrimaryScaffold(
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final size = MediaQuery.of(context).size;
            final centerX = size.width / 2;
            final centerY = size.height / 2;

            // ── Sizes ──────────────────────────────────────────────
            // Logo: starts at 195×137 centered, stays that size
            final double logoW = 195.sp.w;
            final double logoH = 137.sp.h;
            // Text height estimate
            final double textH = 36.h;
            // Gap between logo and text when stacked
            final double gap = 12.h;

            // ── Combined group center (logo + gap + text) ────────
            final double groupH = logoH + gap + textH;
            final double groupTop = centerY - groupH / 2;

            // ── Arc radius: distance from center to final position ─
            // Logo final position: left-center (logo centered vertically, left edge)
            // Text final position: right-center (text centered vertically, right side)
            final double logoFinalX = logoW / 2 + AppWidth.s16;
            final double logoFinalY = centerY;
            final double textFinalX = centerX + (size.width - centerX) / 2;
            final double textFinalY = centerY;

            // Arc radius for the logo (distance from center to final pos)
            final double logoArcRadius = (centerX - logoFinalX).abs();
            // Arc radius for the text
            final double textArcRadius = (textFinalX - centerX).abs();

            // ── Logo position along CCW arc ────────────────────────
            // Starts at top of arc (angle = -π/2 = 12 o'clock relative to center)
            // Ends at left (angle = -π = 9 o'clock) → counter-clockwise quarter
            final double logoAngle = ui.lerpDouble(-pi / 2, -pi, _arcSplit.value)!;
            final double logoCurrentX =
                centerX + logoArcRadius * cos(logoAngle);
            final double logoCurrentY =
                centerY + logoArcRadius * sin(logoAngle);

            // ── Text position along CW arc ─────────────────────────
            // Starts at bottom of arc (angle = π/2 = 6 o'clock)
            // Ends at right (angle = 0 = 3 o'clock) → clockwise quarter
            final double textAngle = ui.lerpDouble(pi / 2, 0, _arcSplit.value)!;
            final double textCurrentX =
                centerX + textArcRadius * cos(textAngle);
            final double textCurrentY =
                centerY + textArcRadius * sin(textAngle);

            // ── Interpolate positions ──────────────────────────────
            // Before arc starts, items are in center stack position
            // After arc ends, items are at their arc-computed positions
            final double logoX = ui.lerpDouble(
              centerX,
              logoCurrentX,
              _arcSplit.value,
            )!;
            final double logoY = ui.lerpDouble(
              groupTop + logoH / 2,
              logoCurrentY,
              _arcSplit.value,
            )!;

            final double textX = ui.lerpDouble(
              centerX,
              textCurrentX,
              _arcSplit.value,
            )!;
            final double textY = ui.lerpDouble(
              groupTop + logoH + gap + textH / 2,
              textCurrentY,
              _arcSplit.value,
            )!;

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: _circleReveal.value >= 1.0
                  ? ColorManager.blueOne500
                  : ColorManager.white,
              child: Stack(
                children: [
                  // ── Phase 1: Circular reveal ───────────────────
                  if (_circleReveal.value < 1.0)
                    ClipPath(
                      clipper: CircleRevealClipper(_circleReveal.value),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: ColorManager.blueOne500,
                      ),
                    ),

                  // ── Phase 2 & 3: Logo ──────────────────────────
                  if (_centerFadeIn.value > 0)
                    Positioned(
                      left: logoX - logoW / 2,
                      top: logoY - logoH / 2,
                      child: Opacity(
                        opacity: _centerFadeIn.value,
                        child: SizedBox(
                          width: logoW,
                          height: logoH,
                          child: Image.asset(
                            IconAssets.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  // ── Phase 2 & 3: Text ──────────────────────────
                  if (_centerFadeIn.value > 0)
                    Positioned(
                      left: textX - _measureTextWidth() / 2,
                      top: textY - textH / 2,
                      child: Opacity(
                        opacity: _centerFadeIn.value,
                        child: Text(
                          _splashText,
                          style: getBoldStyle(
                            fontSize: FontSize.s28,
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.white,
                          ),
                          softWrap: false,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Measures the rendered width of the splash text for accurate centering.
  double _measureTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _splashText,
        style: getBoldStyle(
          fontSize: FontSize.s28,
          fontFamily: FontConstants.fontFamily,
          color: ColorManager.white,
        ),
      ),
textDirection: ui.TextDirection.rtl,
      maxLines: 1,
    )..layout();
    return textPainter.width;
  }
}

// ─── Circular Reveal Clipper ─────────────────────────────────────────────────

class CircleRevealClipper extends CustomClipper<Path> {
  final double progress;

  CircleRevealClipper(this.progress);

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height);
    final radius = maxRadius * progress;

    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
