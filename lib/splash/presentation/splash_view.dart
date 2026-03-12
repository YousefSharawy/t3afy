import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
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

  late Animation<double> _logoFadeIn;
  late Animation<double> _logoScaleDown;
  late Animation<double> _logoMoveDown;
  late Animation<double> _logoMoveLeft;
  late Animation<double> _logoShrink;
  late Animation<double> _textReveal;
  late Animation<double> _buttonAnimation;

  bool _hasCompletedOnboarding = false;

  static final String _splashText = LocaleKeys.app_name.tr();

  @override
  void initState() {
    super.initState();
    // _hasCompletedOnboarding = LocalAppStorage.isOnboardingCompleted();
    context.read<SplashCubit>().start();

    if (_hasCompletedOnboarding) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      _logoFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
        ),
      );

      _logoScaleDown = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
      _logoMoveDown = Tween<double>(begin: 0.0, end: 0.0).animate(_controller);

      _logoMoveLeft = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.70, curve: Curves.easeInOutCubic),
        ),
      );

      _logoShrink = Tween<double>(begin: 1.0, end: 0.55).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.70, curve: Curves.easeInOutCubic),
        ),
      );

      _textReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
        ),
      );

      _buttonAnimation = Tween<double>(
        begin: 0.0,
        end: 0.0,
      ).animate(_controller);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 2200), () {
          // if (mounted) context.go(Routes.home);
        });
      });
    } else {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 3200),
        vsync: this,
      );

      _logoFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
        ),
      );

      _logoScaleDown = Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.20, 0.34, curve: Curves.easeInOut),
        ),
      );

      _logoMoveDown = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.20, 0.34, curve: Curves.easeInOut),
        ),
      );

      _logoMoveLeft = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.38, 0.58, curve: Curves.easeInOutCubic),
        ),
      );

      _logoShrink = Tween<double>(begin: 0.85, end: 0.55).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.38, 0.58, curve: Curves.easeInOutCubic),
        ),
      );

      _textReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.54, 0.78, curve: Curves.easeOut),
        ),
      );

      _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.80, 0.94, curve: Curves.easeOut),
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

  /// Reveals Arabic text letter by letter.
  /// م (index 0) appears first, ي (last index) appears last.
  Widget _buildRevealText(double progress) {
    final chars = _splashText.characters.toList();
    final total = chars.length;
    final visibleCount = progress * total; // ← added

    return RichText(
      softWrap: false,
      text: TextSpan(
        children: List.generate(total, (i) {
          final opacity = (visibleCount - i).clamp(0.0, 1.0); // ← added
          return TextSpan(
            text: chars[i],
            style: getBoldStyle(
              fontSize: FontSize.s28,
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white.withOpacity(opacity), // ← added
            )
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hasCompletedOnboarding
        ? _buildSplash(isReturning: true)
        : _buildSplash(isReturning: false);
  }

  Widget _buildSplash({required bool isReturning}) {
     double aboveCenterStart = 60.0.sp;
     double moveDownAmount = 28.0.sp;

    return BlocListener<SplashCubit,SplashState>(
       listener: (context, state) {
        state.when(initial: () {}, success: (view) => context.go(view));
      },
      child: PrimaryScaffold(
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final size = MediaQuery.of(context).size;
      
            final double verticalOffset =
                -aboveCenterStart + moveDownAmount * _logoMoveDown.value;
      
            // ── Unified logo size across all 3 phases ────────────────
            // Phase 1: 304×213 → Phase 2: 247×173 → Phase 3: 195×137
            final double logoW = lerpDouble(
              lerpDouble(304.sp, 247.sp, (_logoScaleDown.value - 1.0) / (0.85 - 1.0))!,
              195.sp,
              _logoMoveLeft.value,
            )!.w;
            final double logoH = lerpDouble(
              lerpDouble(213.sp, 173.sp, (_logoScaleDown.value - 1.0) / (0.85 - 1.0))!,
              137.sp,
              _logoMoveLeft.value,
            )!.h;
            // Starts centered, slides to left:0 smoothly
            final double logoLeft = lerpDouble(
              size.width / 2 - logoW / 2,
              0,
              _logoMoveLeft.value,
            )!;
            final double logoTop = size.height / 2 + verticalOffset - logoH / 2;
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: ColorManager.blueOne500,
              child: Stack(
                children: [
                  Positioned(
                    top: logoTop,
                    left: logoLeft,
                    child: Opacity(
                      opacity: _logoFadeIn.value,
                      child: SizedBox(
                        width: logoW,
                        height: logoH,
                        child: Image.asset(IconAssets.logo, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  // ── Text to the right of logo ─────────────────────────
                  if (_textReveal.value > 0)
                    Positioned(
                      top: logoTop + logoH / 2 - 20.h,
                      left: AppWidth.s16,
                      right: AppWidth.s2,
                      child: _buildRevealText(_textReveal.value),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}