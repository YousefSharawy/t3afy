import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
      child: Row(
        children: [
          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: ColorManager.blueThree500,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: ColorManager.white,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 8.sp),
          // Text field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.sp),
              decoration: BoxDecoration(
                color: ColorManager.blueOne800.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppRadius.s25),
              ),
              child: TextField(
                controller: controller,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueOne900,
                  fontSize: FontSize.s14,
                ),
                decoration: InputDecoration(
                  hintText: 'أكتب هنا ....',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blueTwo200,
                    fontSize: FontSize.s14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.sp),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}