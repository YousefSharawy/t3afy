import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'app_transitions.dart';
import 'style_manager.dart';
import 'tokens.dart';
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
    dialogTheme: DialogThemeData(
      backgroundColor: ColorManager.surface,
      surfaceTintColor: Colors.transparent,
      barrierColor: ColorManager.scrim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.sheet),
      ),
      titleTextStyle: getSemiBoldStyle(
        color: ColorManager.natural900,
        fontSize: FontSize.s18,
      ),
      contentTextStyle: getRegularStyle(
        color: ColorManager.natural900,
        fontSize: FontSize.s14,
      ),
      elevation: 0,
    ),

    colorScheme: const ColorScheme.light(
      primary: ColorManager.brand,
      onPrimary: ColorManager.white,
      secondary: ColorManager.sprout,
      surface: ColorManager.surface,
      onSurface: ColorManager.ink,
      surfaceTint: Colors.transparent,
      error: ColorManager.error,
      outline: ColorManager.line,
    ),
    canvasColor: ColorManager.canvas,
    cardColor: ColorManager.surface,
    splashFactory: InkRipple.splashFactory,
    highlightColor: ColorManager.brand.withValues(alpha: 0.06),
    splashColor: ColorManager.brand.withValues(alpha: 0.10),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ColorManager.brand,
      linearTrackColor: ColorManager.brandSoft,
      circularTrackColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: ColorManager.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: ColorManager.surface,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: ColorManager.scrim,
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorManager.ink,
      contentTextStyle: getMediumStyle(
        color: ColorManager.onInk,
        fontSize: FontSize.s14,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.input),
      ),
    ),
    iconTheme: const IconThemeData(color: ColorManager.inkMuted),
    pageTransitionsTheme: appPageTransitionsTheme,

    // appBarTheme: _appBarTheme(),
    elevatedButtonTheme: _elevatedButtonTheme(),
    outlinedButtonTheme: _outlineButtonTheme(),
    appBarTheme: _appBarTheme(),
    inputDecorationTheme: _inputDecorationTheme(),
    dividerTheme: DividerThemeData(
      color: ColorManager.divider,
      thickness: 1.3.h,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? ColorManager.white
            : ColorManager.natural300,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? ColorManager.brand
            : ColorManager.line,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? ColorManager.brand
            : ColorManager.surfaceSunken,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s2),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) =>
            BorderSide(width: AppSize.s1, color: ColorManager.primary500),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: ColorManager.natural50,
      hourMinuteColor: ColorManager.primary500.withValues(alpha: 0.08),
      hourMinuteTextColor: ColorManager.natural900,
      dayPeriodColor: ColorManager.primary500.withValues(alpha: 0.08),
      dayPeriodTextColor: ColorManager.natural900,
      dialBackgroundColor: ColorManager.primary500.withValues(alpha: 0.06),
      dialHandColor: ColorManager.primary500,
      dialTextColor: ColorManager.natural900,
      entryModeIconColor: ColorManager.primary500,
      helpTextStyle: getSemiBoldStyle(
        color: ColorManager.natural900,
        fontSize: FontSize.s16,
      ),
      hourMinuteTextStyle: getBoldStyle(
        color: ColorManager.natural900,
        fontSize: FontSize.s40,
      ),
      dayPeriodTextStyle: getMediumStyle(
        color: ColorManager.natural900,
        fontSize: FontSize.s14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s20),
      ),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      dayPeriodBorderSide: BorderSide(
        color: ColorManager.primary500.withValues(alpha: 0.2),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorManager.primary500),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          ColorManager.natural900.withValues(alpha: 0.6),
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: ColorManager.natural50,
      headerBackgroundColor: ColorManager.primary500,
      headerForegroundColor: Colors.white,
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorManager.primary500;
        }
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return ColorManager.natural900;
      }),
      todayBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
      todayForegroundColor: WidgetStatePropertyAll(ColorManager.primary500),
      todayBorder: BorderSide(color: ColorManager.primary500),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s20),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(ColorManager.primary500),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          ColorManager.natural900.withValues(alpha: 0.6),
        ),
      ),
    ),
  );
}

InputDecorationTheme _inputDecorationTheme() {
  return InputDecorationTheme(
    hintStyle: getRegularStyle(
      color: ColorManager.inkFaint,
      fontSize: FontSize.s14,
    ),
    labelStyle: getRegularStyle(
      color: ColorManager.grey,
      fontSize: FontSize.s12,
    ),
    contentPadding: EdgeInsets.fromLTRB(
      AppWidth.s16,
      AppHeight.s12,
      AppWidth.s16,
      AppHeight.s12,
    ),
    filled: true,
    fillColor: ColorManager.surfaceSunken,
    errorStyle: getRegularStyle(
      color: ColorManager.error,
      fontSize: FontSize.s12,
    ),
    errorMaxLines: 2,
    prefixIconColor: ColorManager.inkFaint,
    suffixIconColor: ColorManager.inkFaint,
    focusedBorder: getOutlineInputBorder(
      color: ColorManager.primary500,
      width: 1,
    ),
    disabledBorder: getOutlineInputBorder(),
    enabledBorder: getOutlineInputBorder(),
    errorBorder: getOutlineInputBorder(color: ColorManager.error, width: 1),
    focusedErrorBorder: getOutlineInputBorder(
      color: ColorManager.error,
      width: 1.2,
    ),
  );
}

OutlineInputBorder getOutlineInputBorder({Color? color, double? width}) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: width ?? 1,
      color: color ?? ColorManager.line,
    ),
    borderRadius: BorderRadius.circular(Radii.input),
  );
}

BoxShadow getPrimayBoxShadow() {
  return BoxShadow(
    color: ColorManager.shadow,
    blurRadius: AppRadius.s16,
    offset: Offset(0, AppHeight.s4),
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
      backgroundColor: ColorManager.brand,
      foregroundColor: ColorManager.white,
      disabledBackgroundColor: ColorManager.natural100,
      disabledForegroundColor: ColorManager.inkFaint,
      elevation: 0,
      minimumSize: Size(AppSizes.touch, AppSizes.touch),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.input),
      ),
    ),
  );
}

OutlinedButtonThemeData _outlineButtonTheme() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: getSemiBoldStyle(
        color: ColorManager.brand,
        fontSize: FontSize.s14,
      ),
      foregroundColor: ColorManager.brand,
      backgroundColor: ColorManager.surface,
      elevation: 0,
      minimumSize: Size(AppSizes.touch, AppSizes.touch),
      side: const BorderSide(width: 1, color: ColorManager.line),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.input),
      ),
    ),
  );
}

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: ColorManager.ink),
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,

    centerTitle: true,
    titleTextStyle: getDisplayStyle(
      color: ColorManager.ink,
      fontSize: FontSize.s17,
      fontWeight: FontWeightManager.semiBold,
    ),
    elevation: 0.0,
  );
}
