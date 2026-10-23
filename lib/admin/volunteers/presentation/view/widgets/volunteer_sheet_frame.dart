import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';

/// Shared chrome for the volunteer bottom sheets: surface, sheet radius, drag
/// handle, title row, keyboard + safe-area insets.
class VolunteerSheetFrame extends StatelessWidget {
  const VolunteerSheetFrame({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.height,
    this.scrollable = true,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;

  /// Fixed height (e.g. tall sheets with their own scroll view).
  final double? height;

  /// Wraps [child] in a scroll view. Turn off when the child scrolls itself.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ColorManager.line,
              borderRadius: BorderRadius.circular(Radii.chip),
            ),
          ),
        ),
        SizedBox(height: Space.vl),
        Row(
          children: [
            if (icon != null) ...[
              AppIconBadge(icon: icon!),
              SizedBox(width: Space.m),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.title()),
                  if (subtitle != null) Text(subtitle!, style: AppText.label()),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Space.vl),
        if (scrollable)
          Flexible(child: SingleChildScrollView(child: child))
        else
          Expanded(child: child),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        height: height,
        padding: EdgeInsetsDirectional.fromSTEB(
          Space.gutter,
          Space.vm,
          Space.gutter,
          Space.vl + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: ColorManager.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
        ),
        child: body,
      ),
    );
  }
}

/// Opens one of the volunteer sheets with the shared modal settings.
Future<T?> showVolunteerSheet<T>(BuildContext context, Widget sheet) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => sheet,
  );
}
