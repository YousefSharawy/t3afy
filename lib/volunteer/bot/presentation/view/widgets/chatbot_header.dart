import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';

/// Single header for the bot tab: avatar with a sprout "online" dot,
/// title and availability.
class ChatbotHeader extends StatelessWidget {
  const ChatbotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageHeader(
      title: 'المساعد الذكي',
      subtitle: 'متاح الآن',
      reserveBellSpace: true,
      leading: Padding(
        padding: EdgeInsetsDirectional.only(end: Space.m),
        child: SizedBox.square(
          dimension: 44,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: Image.asset(
                  ImageAssets.botAvatar,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              PositionedDirectional(
                end: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ColorManager.sprout,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorManager.canvas, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
