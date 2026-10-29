import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Error state with a clear retry. Shown only when there is no data to keep
/// on screen — refresh failures on loaded data should use a toast instead.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'تعذّر تحميل البيانات',
  });

  final String message;
  final VoidCallback onRetry;
  final String title;

  @override
  Widget build(BuildContext context) {
    // Scrolls instead of overflowing on short screens / large text.
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: ColorManager.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.offline,
                color: ColorManager.error,
                size: 30,
              ),
            ),
            SizedBox(height: Space.vl),
            Text(title, style: AppText.title(), textAlign: TextAlign.center),
            SizedBox(height: Space.vxs),
            Text(message, style: AppText.label(), textAlign: TextAlign.center),
            SizedBox(height: Space.vl),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(AppIcons.refresh, size: 20),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

typedef AppErrorState = ErrorState;
