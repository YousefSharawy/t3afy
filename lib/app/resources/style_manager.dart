import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  Color color,
  FontWeight fontWeight,
  double? height,
  String? fontFamily,
) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: height,
    fontFamily: fontFamily,
  );
}

TextStyle getLightStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.light,
    height,
    fontFamily,
  );
}

TextStyle getRegularStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.regular,
    height,
    fontFamily,
  );
}

TextStyle getMediumStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.medium,
    height,
    fontFamily,
  );
}

TextStyle getSemiBoldStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.semiBold,
    height,
    fontFamily,
  );
}

TextStyle getBoldStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.bold,
    height,
    fontFamily,
  );
}

TextStyle getExtraBoldStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.extraBold,
    height,
    fontFamily,
  );
}

TextStyle getBlackStyle({
  double fontSize = 12,
  Color color = ColorManager.darkPrimary,
  double? height,
  String? fontFamily,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.black,
    height,
    fontFamily,
  );
}

/// Display face (Alexandria) — screen titles and KPI numbers only.
TextStyle getDisplayStyle({
  double fontSize = 20,
  Color color = ColorManager.ink,
  FontWeight fontWeight = FontWeightManager.bold,
  double? height,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: height ?? 1.25,
    fontFamily: FontConstants.displayFamily,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// Body face with tabular digits — times, counters, hours, points.
TextStyle getNumericStyle({
  double fontSize = 14,
  Color color = ColorManager.ink,
  FontWeight fontWeight = FontWeightManager.semiBold,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    fontFamily: FontConstants.fontFamily,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// Named type scale (sp). Prefer these over ad-hoc FontSize values.
class AppText {
  static TextStyle display({Color color = ColorManager.ink}) =>
      getDisplayStyle(fontSize: FontSize.s28, color: color);
  static TextStyle headline({Color color = ColorManager.ink}) =>
      getDisplayStyle(fontSize: FontSize.s20, color: color);
  static TextStyle title({Color color = ColorManager.ink}) =>
      getSemiBoldStyle(fontSize: FontSize.s17, color: color);
  static TextStyle body({Color color = ColorManager.ink}) =>
      getRegularStyle(fontSize: FontSize.s15, color: color, height: 1.5);
  static TextStyle bodyStrong({Color color = ColorManager.ink}) =>
      getMediumStyle(fontSize: FontSize.s15, color: color, height: 1.5);
  static TextStyle label({Color color = ColorManager.inkMuted}) =>
      getMediumStyle(fontSize: FontSize.s13, color: color);
  static TextStyle caption({Color color = ColorManager.inkFaint}) =>
      getRegularStyle(fontSize: FontSize.s11, color: color);
}
