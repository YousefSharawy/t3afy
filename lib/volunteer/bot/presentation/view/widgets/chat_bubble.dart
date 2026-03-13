import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/volunteer/bot/presentation/view/widgets/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  bool get _isBot => message.sender == MessageSender.bot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Row(
        mainAxisAlignment: _isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isBot) ...[
            // Bot avatar
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(ImageAssets.botAvatar),
            ),
            SizedBox(width: 8.sp),
          ],
          // Message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 10.sp),
              decoration: BoxDecoration(
                color: _isBot ? null : ColorManager.blueOne600,
                gradient: _isBot
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorManager.blueOne900,
                          ColorManager.blueOne800,
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.sp),
                  topRight: Radius.circular(16.sp),
                  bottomLeft: _isBot
                      ? Radius.circular(4.sp)
                      : Radius.circular(16.sp),
                  bottomRight: _isBot
                      ? Radius.circular(16.sp)
                      : Radius.circular(4.sp),
                ),
              ),
              child: Text(
                message.text,
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.white,
                  fontSize: FontSize.s12,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          if (!_isBot) ...[
            SizedBox(width: 8.sp),
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: ColorManager.blueOne600,
              child: Icon(Icons.person, size: 18.sp, color: ColorManager.white),
            ),
          ],
        ],
      ),
    );
  }
}
