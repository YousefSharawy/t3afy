import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ChatbotHeader extends StatelessWidget {
  const ChatbotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'المساعد الذكى',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.blueOne900,
              fontSize: FontSize.s16,
            ),
          ),
        ],
      ),
    );
  }
}
