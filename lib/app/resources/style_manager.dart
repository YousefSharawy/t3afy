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
    String ? fontFamily,

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
    String ? fontFamily,

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
  double? height,    String ? fontFamily,

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
      String ? fontFamily,

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
      String ? fontFamily,

}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeightManager.extraBold,
    height,
    fontFamily,
  );
}
