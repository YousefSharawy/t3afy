import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';

/// Title row used at the top of every tab and pushed screen, so headers sit at
/// the same height everywhere.
///
/// * Tab screens: leave [showBack] false; space for the floating bell (which
///   sits on the end side) is reserved automatically via [reserveBellSpace].
/// * Pushed screens: [showBack] true.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.actions = const [],
    this.reserveBellSpace = false,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final bool reserveBellSpace;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        showBack ? Space.xs : Space.gutter,
        Space.vs,
        Space.gutter,
        Space.vm,
      ),
      // Same height on every screen (≥ the floating bell), so titles line up
      // with the bell whether or not the header has actions.
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: AppSizes.touch),
        child: Row(
          children: [
            if (showBack)
              IconButton(
                tooltip: 'رجوع',
                onPressed: onBack ?? () => context.pop(),
                icon: const Icon(AppIcons.back, color: ColorManager.ink),
              ),
            ?leading,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppText.headline(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) Text(subtitle!, style: AppText.label()),
                ],
              ),
            ),
            ...actions,
            if (reserveBellSpace) SizedBox(width: AppNavShell.bellReserve),
          ],
        ),
      ),
    );
  }
}
