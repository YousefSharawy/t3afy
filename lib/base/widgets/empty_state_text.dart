import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Designed empty state: tinted icon, one-line title, optional hint and action.
/// An empty screen is an invitation to act — give it an action when one exists.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = AppIcons.empty,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final circle = compact ? 48.0 : 64.0;
    // Centered when it fits; scrolls instead of overflowing when it's the
    // whole body of a short tab/sheet. A SingleChildScrollView (not a
    // LayoutBuilder) so it also works in ListViews and inside
    // SliverFillRemaining(hasScrollBody: false), which asks for intrinsics.
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Space.xl,
            vertical: compact ? Space.vl : Space.vxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: circle,
                height: circle,
                decoration: const BoxDecoration(
                  color: ColorManager.brandSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: ColorManager.brand,
                  size: circle * 0.46,
                ),
              ),
              SizedBox(height: Space.vm),
              Text(
                title,
                style: compact ? AppText.bodyStrong() : AppText.title(),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                SizedBox(height: Space.vxs),
                Text(
                  message!,
                  style: AppText.label(),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                SizedBox(height: Space.vl),
                OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
