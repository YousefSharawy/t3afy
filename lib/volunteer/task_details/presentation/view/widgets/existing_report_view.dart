import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

/// The volunteer's submitted report: review status and supervisor feedback.
class ExistingReportView extends StatelessWidget {
  const ExistingReportView({super.key, required this.report});

  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    final status = report['status'] as String? ?? 'pending';
    final style = StatusBadge.styleOf(status);
    final icon = switch (status) {
      'approved' => AppIcons.done,
      'rejected' => Icons.cancel_rounded,
      _ => Icons.hourglass_top_rounded,
    };
    final feedback = report['admin_feedback'] as String?;

    return AppCard(
      accent: style.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBadge(icon: icon, color: style.accent, size: 40),
              SizedBox(width: Space.m),
              Expanded(
                child: Text(
                  'لقد قمت برفع تقرير لهذه المهمة',
                  style: AppText.bodyStrong(),
                ),
              ),
              StatusBadge(status: status),
            ],
          ),
          if (feedback != null && feedback.trim().isNotEmpty) ...[
            SizedBox(height: Space.vm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Space.m),
              decoration: BoxDecoration(
                color: ColorManager.surfaceSunken,
                borderRadius: BorderRadius.circular(Radii.input),
                border: Border.all(color: ColorManager.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ملاحظات المشرف', style: AppText.label()),
                  SizedBox(height: Space.vxs),
                  Text(feedback, style: AppText.body()),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
