import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onPress;

  const ProfileLogoutButton({
    super.key,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryElevatedButton(
      backGroundColor: const Color(0xff970909),
      title: 'تسجيل خروج',
      onPress: onPress,
      textStyle: getBoldStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s16,
        color: ColorManager.white,
      ),
    );
  }
}
