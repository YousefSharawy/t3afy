import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/primary_widgets.dart';

class FirstOnboarding extends StatelessWidget {
  const FirstOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Space.gutter),
                child: Column(
                  children: [
                    SizedBox(height: Space.vxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'معًا نبدأ طريق التعافي',
                            style: getDisplayStyle(fontSize: FontSize.s24),
                          ),
                        ),
                        SizedBox(width: Space.m),
                        Image.asset(
                          IconAssets.logo,
                          width: AppWidth.s67,
                          height: AppHeight.s47,
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(height: Space.vxl),
                    Image.asset(
                      ImageAssets.onBoarding,
                      fit: BoxFit.contain,
                      width: AppWidth.s339,
                      height: AppHeight.s224,
                    ),
                    SizedBox(height: Space.vxxl),
                    Text(
                      'كن السبب في إنقاذ حياة',
                      textAlign: TextAlign.center,
                      style: AppText.headline(),
                    ),
                    SizedBox(height: Space.vs),
                    Text(
                      'تطوّعك اليوم قد يُغيّر مسار حياة شخص يحتاجك',
                      textAlign: TextAlign.center,
                      style: AppText.body(color: ColorManager.inkMuted),
                    ),
                    const Spacer(),
                    SizedBox(height: Space.vxl),
                    PrimaryElevatedButton(
                      width: double.infinity,
                      title: 'ابدأ رحلة التطوع',
                      onPress: () => context.go(Routes.login),
                    ),
                    SizedBox(height: Space.vl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
