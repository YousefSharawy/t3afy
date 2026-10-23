import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Sheet handle + title row with a close button.
class ReportFormHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onClose;

  const ReportFormHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: Space.vm),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: ColorManager.line,
            borderRadius: BorderRadius.circular(Radii.chip),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            Space.gutter,
            Space.vs,
            Space.xs,
            Space.vs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.headline()),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(
                        subtitle!,
                        style: AppText.label(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'إغلاق',
                onPressed: onClose,
                icon: const Icon(AppIcons.x, color: ColorManager.inkMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
