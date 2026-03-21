import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/quick_actions_chips.dart';
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.onChipTap,
  });
  final ChatMessage message;
  final Function(String)? onChipTap;
  bool get _isBot => message.sender == MessageSender.bot;
  static const double _avatarSize = 32.0;
  static const double _avatarSpacing = 8.0;
  static const double _chipsIndent = _avatarSize + _avatarSpacing; // 40
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppHeight.s8,horizontal: AppWidth.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  _isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isBot) ...[
                  CircleAvatar(
                    radius: (_avatarSize / 2).sp,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(ImageAssets.botAvatar),
                  ),
                  SizedBox(width: _avatarSpacing.sp),
                ],
                if (_isBot)
                  Flexible(child: _botBubble())
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.72,
                    ),
                    child: _userBubble(),
                  ),
              ],
            ),
            if (_isBot && message.quickActions.isNotEmpty) ...[
              SizedBox(height: 8.sp),
              Padding(
                padding: EdgeInsets.only(left: _chipsIndent.sp),
                child: QuickActionChips(
                  actions: message.quickActions,
                  onTap: onChipTap ?? (_) {},
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _botBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.sp),
          topRight: Radius.circular(16.sp),
          bottomLeft: Radius.circular(4.sp),
          bottomRight: Radius.circular(16.sp),
        ),
      ),
      child: Text(
        message.text,
        textDirection: TextDirection.rtl,
        style: getMediumStyle(
          fontFamily: FontConstants.fontFamily,
          color: ColorManager.natural700,
          fontSize: FontSize.s12,
        ),
      ),
    );
  }

  Widget _userBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s22, vertical: AppHeight.s9),
      decoration: BoxDecoration(
        color: ColorManager.blueOne500,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.sp),
          topRight: Radius.circular(16.sp),
          bottomLeft: Radius.circular(16.sp),
          bottomRight: Radius.circular(4.sp),
        ),
      ),
      child: Text(
        message.text,
        textDirection: TextDirection.rtl,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          color: ColorManager.natural50,
          fontSize: FontSize.s12,
        ),
      ),
    );
  }
}
