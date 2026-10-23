import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radii.chip),
      borderSide: const BorderSide(color: ColorManager.line),
    );
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Space.gutter),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 4,
              style: AppText.body(),
              decoration: InputDecoration(
                hintText: 'اكتب هنا…',
                hintStyle: AppText.body(color: ColorManager.inkFaint),
                filled: true,
                fillColor: ColorManager.surface,
                isDense: true,
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: Space.l,
                  vertical: Space.vm,
                ),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: ColorManager.brand),
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          SizedBox(width: Space.s),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final enabled = value.text.trim().isNotEmpty;
              return IconButton.filled(
                tooltip: 'إرسال',
                onPressed: enabled ? onSend : null,
                style: IconButton.styleFrom(
                  backgroundColor: ColorManager.brand,
                  foregroundColor: ColorManager.white,
                  disabledBackgroundColor: ColorManager.natural100,
                  disabledForegroundColor: ColorManager.inkFaint,
                  minimumSize: Size.square(AppSizes.touch),
                ),
                icon: const Icon(AppIcons.send),
              );
            },
          ),
        ],
      ),
    );
  }
}
