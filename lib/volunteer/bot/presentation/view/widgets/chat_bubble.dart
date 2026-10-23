import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/quick_actions_chips.dart';

/// Bot messages sit on the start side (with the avatar), the user's on the
/// end side; corners are directional so the tail follows RTL.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, this.onChipTap});

  final ChatMessage message;
  final ValueChanged<String>? onChipTap;

  bool get _isBot => message.sender == MessageSender.bot;

  static const double _avatarSize = 32;

  @override
  Widget build(BuildContext context) {
    final big = Radius.circular(Radii.card);
    final tail = Radius.circular(Radii.small / 2);
    final maxWidth = MediaQuery.sizeOf(context).width * 0.75;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: Space.m + Space.xxs,
          vertical: Space.vs + 2,
        ),
        decoration: BoxDecoration(
          color: _isBot ? ColorManager.surface : ColorManager.brand,
          borderRadius: BorderRadiusDirectional.only(
            topStart: _isBot ? tail : big,
            topEnd: big,
            bottomStart: big,
            bottomEnd: _isBot ? big : tail,
          ),
        ),
        child: Text(
          message.text,
          style: _isBot
              ? AppText.body()
              : AppText.body(color: ColorManager.white),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Space.vxs + 2),
      child: Column(
        crossAxisAlignment: _isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: _isBot
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isBot) ...[
                ClipOval(
                  child: Image.asset(
                    ImageAssets.botAvatar,
                    width: _avatarSize,
                    height: _avatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Space.s),
                Flexible(child: bubble),
              ] else
                bubble,
            ],
          ),
          if (_isBot && message.quickActions.isNotEmpty) ...[
            SizedBox(height: Space.vs),
            Padding(
              padding: EdgeInsetsDirectional.only(start: _avatarSize + Space.s),
              child: QuickActionChips(
                actions: message.quickActions,
                onTap: onChipTap ?? (_) {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}
