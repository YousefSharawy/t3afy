import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/primary_widgets.dart';

class FirstOnboarding extends StatelessWidget {
  const FirstOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppWidth.s15),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            SizedBox(height: AppHeight.s85),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppWidth.s12,
              ),
              child: Row(
                children: [
                  Text(
                    "معًا نبدأ طريق التعافى",
                    style:
                        getExtraBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.primary,
                          fontSize: FontSize.s24,
                        ).copyWith(
                          shadows: [
                            // ← added
                            Shadow(
                              color: Colors.black.withAlpha(65),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                  ),
                  SizedBox(width: AppWidth.s17),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(65),
                            BlendMode.srcIn,
                          ),
                          child: Transform.translate(
                            offset: const Offset(0, 4), // shadow offset (x, y)
                            child: Image.asset(
                              IconAssets.logo,
                              width: AppWidth.s67,
                              height: AppHeight.s47,
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        IconAssets.logo,
                        width: AppWidth.s67,
                        height: AppHeight.s47,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppHeight.s57),
            Image.asset(
              fit: BoxFit.contain,
              ImageAssets.onBoarding,
              width: AppWidth.s356,
              height: AppHeight.s236,
            ),
            SizedBox(height: AppHeight.s31),
            Text(
              "ادعم التعافي",
              style:
                  getExtraBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.primary,
                    fontSize: FontSize.s24,
                  ).copyWith(
                    shadows: [
                      // ← added
                      Shadow(
                        color: Colors.black.withAlpha(65),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
            ),
            SizedBox(height: AppHeight.s15),
            Text(
              "انضم لمتطوعين يساعدون الناس على التغلب على الإدمان",
              style:
                  getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ).copyWith(
                    shadows: [
                      // ← added
                      Shadow(
                        color: Colors.black.withAlpha(65),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
            ),
            SizedBox(height: AppHeight.s57),
            PrimaryElevatedButton(
              title: 'ابدأ الآن',
              onPress: () {
                context.go(Routes.login);
              },
              textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s24,
                color: ColorManager.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
