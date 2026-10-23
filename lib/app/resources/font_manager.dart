import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontConstants {
  /// UI / body face. Tabular digits for times, counters and hours.
  static const String fontFamily = 'IBMPlexSansArabic';

  /// Display face — titles and KPI numbers only, use with restraint.
  static const String displayFamily = 'Alexandria';

  // Legacy families now resolve to the body face.
  static const String almaraiFontFamily = fontFamily;
  static const String interFamily = fontFamily;
  static const String arialFamily = 'Arial';
}

class FontWeightManager {
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

class FontSize {
  static double s8 = 8.sp;
  static double s9 = 9.sp;
  static double s10 = 10.sp;
  static double s11 = 11.sp;
  static double s12 = 12.sp;
  static double s13 = 13.sp;
  static double s14 = 14.sp;
  static double s15 = 15.sp;
  static double s16 = 16.sp;
  static double s17 = 17.sp;
  static double s18 = 18.sp;
  static double s19 = 19.sp;
  static double s20 = 20.sp;
  static double s22 = 22.sp;
  static double s24 = 24.sp;
  static double s25 = 25.sp;
  static double s26 = 26.sp;
  static double s27 = 27.sp;
  static double s28 = 28.sp;
  static double s30 = 30.sp;
  static double s32 = 32.sp;
  static double s36 = 36.sp;
  static double s40 = 40.sp;
  static double s42 = 42.sp;
  static double s48 = 48.sp;
}
