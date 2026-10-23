import 'package:flutter/material.dart';

/// T3afy "Rising together" palette — derived from the logo:
/// teal = the team, deep root = ink, sprout = growth/done, star = goals reached.
///
/// Prefer the semantic tokens (brand, ink, canvas, surface, line, sprout, star…).
/// The numbered scales and legacy aliases below are kept so existing screens
/// keep compiling; they now resolve to the new palette.
class ColorManager {
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // ── Semantic tokens (use these in new code) ──────────────────────────────
  static const brand = Color(0xFF00728F); // Field Teal — from the logo
  static const brandStrong = Color(0xFF005368);
  static const brandSoft = Color(0xFFE3F1F4);
  static const ink = Color(0xFF0B2A33); // Deep Root — primary text, command band
  static const inkMuted = Color(0xFF4A6169); // secondary text
  static const inkFaint = Color(0xFF7C9097); // captions / meta
  static const canvas = Color(0xFFEEF5F6); // Canopy Mist — scaffold
  static const surface = Color(0xFFFFFFFF); // cards / sheets
  static const surfaceSunken = Color(0xFFF5F9FA); // inputs, inset areas
  static const line = Color(0xFFD7E3E6); // dividers / borders
  static const sprout = Color(0xFF2FA37A); // done / progress (fills)
  static const sproutText = Color(0xFF1E7F5C); // done (text on light)
  static const sproutSoft = Color(0xFFDDF3EA);
  static const star = Color(0xFFF2B230); // goals met, top rank — use rarely
  static const starText = Color(0xFF8A5E00);
  static const starSoft = Color(0xFFFDF3DA);
  static const onInk = Color(0xFFE6F1F3); // text on Deep Root
  static const onInkMuted = Color(0xFF9DB6BD);
  static const scrim = Color(0x8C0B2A33);
  static const shadow = Color(0x0F0B2A33);

  // Primary scale (teal) — 500 is the logo teal
  static const primary50 = Color(0xFFE3F1F4);
  static const primary100 = Color(0xFFBFDDE4);
  static const primary200 = Color(0xFF93C5D1);
  static const primary300 = Color(0xFF5FA8BA);
  static const primary400 = Color(0xFF2E8CA3);
  static const primary500 = brand;
  static const primary600 = Color(0xFF00657F);
  static const primary700 = brandStrong;
  static const primary800 = Color(0xFF0D3F4C);
  static const primary900 = ink;

  // Neutral scale (ink-tinted)
  static const natural50 = canvas;
  static const natural100 = Color(0xFFE4ECEE);
  static const natural200 = line;
  static const natural300 = Color(0xFFB3C3C8);
  static const natural400 = inkFaint;
  static const natural500 = Color(0xFF5F757C);
  static const natural600 = inkMuted;
  static const natural700 = Color(0xFF34494F);
  static const natural800 = Color(0xFF1C343C);
  static const natural900 = ink;

  // Semantic — Status (text colors are AA on their *Light background)
  static const success = sproutText;
  static const successLight = sproutSoft;
  static const warning = Color(0xFFB26A00);
  static const warningLight = Color(0xFFFDF0D5);
  static const error = Color(0xFFC93A3A);
  static const errorLight = Color(0xFFFBE4E4);
  static const info = Color(0xFF2F6FD6);
  static const infoLight = Color(0xFFE2ECFB);

  static const accentSand = starSoft;
  static const accentLavender = Color(0xFFE6EAF7);
  static const accentMint = sproutSoft;

  // ── Older semantic aliases ────────────────────────────────────────────────
  static const background = canvas;
  static const shimmerBaseColor = natural100;
  static const shimmerHighlightedColor = surfaceSunken;
  static const divider = line;
  static const navbarInactiveItem = natural300;
  static const navbarInactiveItemTitle = inkFaint;
  static const grey = natural500;
  static const darkGrey = natural700;
  static const darkPrimary = ink;
  static const fieldBackground = surfaceSunken;
  static const fieldBorder = line;
  static const chevronRight = inkFaint;
  static const secondary = primary400;
  static const cyanPrimary = brand;
  static const cyanDark = primary600;
  static const lightTealSoft = brandSoft;
  static const tealSoft = primary100;
  static const navyCard = natural800;
  static const navyLight = natural700;
  static const amber400 = star;
  static const amber500 = star;
  static const emeraldGreen = sprout;
  static const neonGreen = sprout;
  static const violet300 = accentLavender;
  static const violet600 = primary700;
  static const violet700 = primary700;
  static const red = error;
  static const darkRed = Color(0xFF8E2323);
  static const lightError = errorLight;
  static const lightGrey = natural100;

  // ── blueOne* backward-compatible aliases ──────────────────────────────────
  static const blueOne50 = primary50;
  static const blueOne100 = primary100;
  static const blueOne200 = primary200;
  static const blueOne300 = primary300;
  static const blueOne400 = primary400;
  static const blueOne500 = primary500;
  static const blueOne600 = primary600;
  static const blueOne700 = primary700;
  static const blueOne800 = natural800;
  static const blueOne900 = ink;

  // ── blueTwo* backward-compatible aliases ──────────────────────────────────
  static const blueTwo100 = primary100;
  static const blueTwo200 = primary200;
  static const blueTwo300 = primary300;
  static const blueTwo400 = primary400;
  static const blueTwo500 = primary500;
  static const blueTwo600 = primary600;
  static const blueTwo900 = ink;

  // ── blueThree* backward-compatible aliases ────────────────────────────────
  static const blueThree300 = accentMint;
  static const blueThree400 = primary400;
  static const blueThree500 = primary500;
  static const blueThree600 = primary600;
  static const blueThree900 = ink;

  // ── lightGray* / darkGray* backward-compatible aliases ───────────────────
  static const lightGray400 = natural400;
  static const lightGray700 = natural700;
  static const darkGray = natural700;
}
