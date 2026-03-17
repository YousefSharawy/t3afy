import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  required Color confirmColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ColorManager.blueOne800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      title: Text(
        title,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s16,
          color: Colors.white,
        ),
        textDirection: TextDirection.rtl,
      ),
      content: Text(
        body,
        style: getMediumStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s13,
          color: Colors.white70,
        ),
        textDirection: TextDirection.rtl,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            '\u0625\u0644\u063a\u0627\u0621',
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white54,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            confirmLabel,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: confirmColor,
            ),
          ),
        ),
      ],
    ),
  );
  return result == true;
}
