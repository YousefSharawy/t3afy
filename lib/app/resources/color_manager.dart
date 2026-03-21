import 'package:flutter/material.dart';

class ColorManager {
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // Primary (Teal/Cyan brand color)
  static const primary50  = Color(0xFFE6F2F5);
  static const primary100 = Color(0xFFB0D3DF);
  static const primary200 = Color(0xFF8AC0D0);
  static const primary300 = Color(0xFF54A3BB);// gradient1
  static const primary400 = Color(0xFF3391AD);
  static const primary500 = Color(0xFF007599); // elevated buttons, splash screen // gradient1
  static const primary600 = Color(0xFF006B8B);
  static const primary700 = Color(0xFF00546D);
  static const primary800 = Color(0xFF004054);
  static const primary900 = Color(0xFF003140);

  // Neutral / Natural
  static const natural50  = Color(0xFFF7F8FA); // background
  static const natural100 = Color(0xFFEEF0F4);
  static const natural200 = Color(0xFFD8DCE3);
  static const natural300 = Color(0xFFB0B7C3);
  static const natural400 = Color(0xFF8E96A4);
  static const natural500 = Color(0xFF6B7280);
  static const natural600 = Color(0xFF4B5563);
  static const natural700 = Color(0xFF374151);
  static const natural800 = Color(0xFF1F2937);
  static const natural900 = Color(0xFF111827);

  // Semantic — Status
  static const success      = Color(0xFF16A34A); 
  static const successLight = Color(0xFFDCFCE7);
  static const warning      = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const error        = Color(0xFFDC2626);
  static const errorLight   = Color(0xFFFEE2E2);
  static const info         = Color(0xFF2563EB);
  static const infoLight    = Color(0xFFDBEAFE);

  static const accentSand     = Color(0xFFF5F0E8);
  static const accentLavender = Color(0xFFEDE9FE);
  static const accentMint     = Color(0xFFD1FAE5);

  // ── Semantic aliases (new names) ──────────────────────────────────────────
  static const background              = natural50;
  static const shimmerBaseColor        = natural100;
  static const shimmerHighlightedColor = natural200;
  static const divider                 = natural200;
  static const navbarInactiveItem      = natural300;
  static const navbarInactiveItemTitle = natural400;
  static const grey                    = natural500;
  static const darkGrey                = natural700;
  static const darkPrimary             = natural900;
  static const fieldBackground         = natural50;
  static const fieldBorder             = natural200;
  static const chevronRight            = natural400;
  static const secondary               = primary400;
  static const cyanPrimary             = primary500;
  static const cyanDark                = primary600;
  static const lightTealSoft           = primary50;
  static const tealSoft                = primary100;
  static const navyCard                = natural800;
  static const navyLight               = natural700;
  static const amber400                = warning;
  static const amber500                = Color(0xFFF59E0B);
  static const emeraldGreen            = success;
  static const neonGreen               = Color(0xFF66F839);
  static const violet300               = accentLavender;
  static const violet600               = Color(0xFF703DEB);
  static const violet700               = Color(0xFF7C3AED);
  static const red                     = error;
  static const darkRed                 = Color(0xFF970909);
  static const lightError              = errorLight;
  static const lightGrey               = natural100;

  // ── blueOne* backward-compatible aliases ──────────────────────────────────
  static const blueOne50  = primary50;
  static const blueOne100 = primary100;
  static const blueOne200 = primary200;
  static const blueOne300 = primary300;
  static const blueOne400 = primary400;
  static const blueOne500 = primary500;
  static const blueOne600 = primary500;
  static const blueOne700 = primary700;
  static const blueOne800 = natural800;
  static const blueOne900 = natural900;

  // ── blueTwo* backward-compatible aliases ──────────────────────────────────
  static const blueTwo100 = primary100;
  static const blueTwo200 = primary200;
  static const blueTwo300 = primary300;
  static const blueTwo400 = primary400;
  static const blueTwo500 = primary500;
  static const blueTwo600 = primary600;
  static const blueTwo900 = natural900;

  // ── blueThree* backward-compatible aliases ────────────────────────────────
  static const blueThree300 = accentMint;
  static const blueThree400 = primary400;
  static const blueThree500 = primary500;
  static const blueThree600 = primary600;
  static const blueThree900 = natural900;

  // ── lightGray* / darkGray* backward-compatible aliases ───────────────────
  static const lightGray400 = natural400;
  static const lightGray700 = natural700;
  static const darkGray     = natural700;
}