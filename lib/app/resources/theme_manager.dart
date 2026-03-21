import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'style_manager.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorManager.primary500,
      selectionColor: ColorManager.primary500.withValues(alpha: 0.3),
      selectionHandleColor: ColorManager.primary500,
    ),
    useMaterial3: false,
    primaryColor: ColorManager.primary500,
    scaffoldBackgroundColor: ColorManager.natural50,
    fontFamily: FontConstants.fontFamily,
    textTheme: _textTheme(),
    dialogTheme: DialogThemeData(backgroundColor: Colors.white),

    colorScheme: const ColorScheme.light(
      primary: ColorManager.primary500,
      surface: ColorManager.primary500,
      surfaceTint: Colors.transparent,
      secondary: ColorManager.secondary,
    ),

    // appBarTheme: _appBarTheme(),
    elevatedButtonTheme: _elevatedButtonTheme(),
    outlinedButtonTheme: _outlineButtonTheme(),
    appBarTheme: _appBarTheme(),
    inputDecorationTheme: _inputDecorationTheme(),
    dividerTheme: DividerThemeData(
      color: ColorManager.divider,
      thickness: 1.3.h,
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(ColorManager.primary500),
      trackOutlineColor: WidgetStatePropertyAll(Colors.grey),
      trackColor: WidgetStatePropertyAll(Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s2),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(width: AppSize.s1, color: ColorManager.primary500),
      ),
    ),
  );
}

InputDecorationTheme _inputDecorationTheme() {
  return InputDecorationTheme(
    hintStyle: getLightStyle(color: ColorManager.grey, fontSize: FontSize.s14),
    labelStyle: getRegularStyle(
      color: ColorManager.grey,
      fontSize: FontSize.s12,
    ),
    contentPadding: EdgeInsets.fromLTRB(
      AppWidth.s16,
      AppHeight.s9,
      AppWidth.s16,
      AppHeight.s9,
    ),
    filled: true,
    fillColor: Color(0xffF1F1F1),
    constraints: BoxConstraints(
      maxHeight: AppHeight.s44,
      minHeight: AppHeight.s44,
    ),
    focusedBorder: getOutlineInputBorder(color: ColorManager.primary500, width: 1),
    disabledBorder: getOutlineInputBorder(),
    enabledBorder: getOutlineInputBorder(),
    errorBorder: getOutlineInputBorder(color: ColorManager.error, width: 1),
    focusedErrorBorder: getOutlineInputBorder(),
  );
}

getOutlineInputBorder({Color? color, double? width}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: width ?? 0,
      color: color ?? Color(0xff1B1D21).withValues(alpha: 0.1),
    ),
    borderRadius: BorderRadius.circular(AppRadius.s30),
  );
}

BoxShadow getPrimayBoxShadow() {
  return BoxShadow(
    color: ColorManager.black.withValues(alpha: 0.07),
    blurRadius: AppRadius.s10,
    spreadRadius: AppRadius.s1,
    offset: const Offset(0, 0),
  );
}

TextTheme _textTheme() {
  return TextTheme(
    headlineLarge: null,
    headlineMedium: getBoldStyle(fontSize: FontSize.s18),
    headlineSmall: getRegularStyle(fontSize: FontSize.s18),
    titleLarge: getBoldStyle(fontSize: FontSize.s16),
    titleMedium: getBoldStyle(fontSize: FontSize.s14),
    titleSmall: getRegularStyle(fontSize: FontSize.s16),
    labelLarge: getBoldStyle(fontSize: FontSize.s12),
    labelMedium: getRegularStyle(fontSize: FontSize.s14),
    labelSmall: getRegularStyle(fontSize: FontSize.s12),
    bodyLarge: getBoldStyle(fontSize: FontSize.s10),
    bodyMedium: null,
    bodySmall: getRegularStyle(fontSize: FontSize.s10),
  );
}

ElevatedButtonThemeData _elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: getBoldStyle(
        color: ColorManager.white,
        fontSize: FontSize.s14,
      ),
      backgroundColor: ColorManager.primary500,
      foregroundColor: ColorManager.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s30),
      ),
    ),
  );
}

_outlineButtonTheme() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: getRegularStyle(
        color: ColorManager.primary500,
        fontSize: FontSize.s14,
      ),
      foregroundColor: ColorManager.primary500,
      backgroundColor: ColorManager.white,
      elevation: 0,
      side: BorderSide(width: 1, color: Color(0xffE6E6E6)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s30),
      ),
    ),
  );
}

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: ColorManager.black),
    backgroundColor: Colors.transparent,

    centerTitle: true,
    titleTextStyle: getBoldStyle(
      color: ColorManager.darkPrimary,
      fontSize: FontSize.s16,
    ),
    elevation: 0.0,
  );
}
