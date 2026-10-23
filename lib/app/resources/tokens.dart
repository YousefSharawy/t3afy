import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';

/// 4/8 spacing rhythm. Use instead of one-off AppWidth/AppHeight values.
class Space {
  static double get xxs => 2.w;
  static double get xs => 4.w;
  static double get s => 8.w;
  static double get m => 12.w;
  static double get l => 16.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;

  /// Horizontal page gutter used by every screen.
  static double get gutter => 16.w;

  static double get vxs => 4.h;
  static double get vs => 8.h;
  static double get vm => 12.h;
  static double get vl => 16.h;
  static double get vxl => 24.h;
  static double get vxxl => 32.h;
}

class Radii {
  static double get chip => 999;
  static double get input => 12.r;
  static double get card => 16.r;
  static double get sheet => 24.r;
  static double get small => 8.r;
}

class AppMotion {
  static const fast = Duration(milliseconds: 140);
  static const base = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 320);
  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;
  static const pressScale = 0.97;

  /// True when the OS asks for reduced motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static Duration of(BuildContext context, [Duration d = base]) =>
      reduced(context) ? Duration.zero : d;
}

class AppShadows {
  /// The single elevation used by cards, the nav bar and floating buttons.
  static List<BoxShadow> get card => [
    BoxShadow(
      color: ColorManager.shadow,
      blurRadius: 16.r,
      offset: Offset(0, 4.h),
    ),
  ];
}

class AppSizes {
  static double get touch => 48.r;
  static double get iconS => 16.r;
  static double get iconM => 20.r;
  static double get iconL => 24.r;
}
