import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool isDestructive = false,
}) async {
  final confirmColor = isDestructive
      ? ColorManager.error
      : ColorManager.primary500;

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: ColorManager.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actionsPadding: EdgeInsets.fromLTRB(
          AppWidth.s16,
          0,
          AppWidth.s16,
          AppHeight.s16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s24),
        ),
        title: Text(
          title,
          style: getDisplayStyle(
            color: ColorManager.ink,
            fontSize: FontSize.s18,
            fontWeight: FontWeightManager.semiBold,
          ),
        ),
        content: Text(
          body,
          style: getRegularStyle(
            color: ColorManager.inkMuted,
            height: 1.5,
            fontSize: FontSize.s14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'إلغاء',
              style: getMediumStyle(
                fontSize: FontSize.s14,
                color: ColorManager.inkMuted,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: ColorManager.white,
              elevation: 0,
              minimumSize: Size(AppWidth.s96, AppHeight.s44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(ctx, true);
            },
            child: Text(
              confirmLabel,
              style: getMediumStyle(
                fontSize: FontSize.s14,
                color: ColorManager.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  return result == true;
}
