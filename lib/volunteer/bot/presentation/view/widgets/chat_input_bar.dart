import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: AppWidth.s18,
        end: AppWidth.s18,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural50,
                  fontSize: FontSize.s14,
                ),
                decoration: InputDecoration(
                  hintText: 'أكتب هنا ....',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural50,
                    fontSize: FontSize.s14,
                  ),
                  filled: true,
                  fillColor: ColorManager.primary500,
                  contentPadding: EdgeInsets.all(10.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s25),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s25),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            SizedBox(width: 10.sp),
            // Send icon
            GestureDetector(onTap: onSend, child: Image.asset(IconAssets.send)),
          ],
        ),
      ),
    );
  }
}
