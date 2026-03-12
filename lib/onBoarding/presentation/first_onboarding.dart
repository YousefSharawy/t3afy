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
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppWidth.s18),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            SizedBox(height: AppHeight.s79),
            Row(
              children: [
                Text(
                  "معًا نبدأ طريق التعافى",
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blue600,
                    fontSize: FontSize.s24,
                  ),
                ),
                SizedBox(width: AppWidth.s37),
                Image.asset(
                  IconAssets.logo,
                  width: AppWidth.s67,
                  height: AppHeight.s47,
                ),
              ],
            ),
            SizedBox(height: AppHeight.s80),
            Image.asset(
              fit: BoxFit.contain,
              ImageAssets.onBoarding,
              width: AppWidth.s339,
              height: AppHeight.s224,
            ),
            SizedBox(height: AppHeight.s48),
            Text(
              "كن السبب في إنقاذ حياة",
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blue600,
                fontSize: FontSize.s20,
              ),
            ),
            SizedBox(height: AppHeight.s8),
            Text(
              "تطوّعك اليوم قد يُغيّر مسار حياة شخص يحتاجك",
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blue600,
                fontSize: FontSize.s14,
              ),
            ),
            SizedBox(height: AppHeight.s140),
            PrimaryElevatedButton(
              buttonRadius: AppRadius.s8,
              title: 'ابدأ رحلة التطوع',
              onPress: () {
                context.go(Routes.login);
              },
              textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: ColorManager.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
