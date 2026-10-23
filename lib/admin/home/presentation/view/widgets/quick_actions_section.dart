import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'home_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.onNewCampaign,
    this.onFullReport,
    this.onSendAnnouncement,
    this.isExportingPdf = false,
  });

  final VoidCallback? onNewCampaign;
  final VoidCallback? onFullReport;
  final VoidCallback? onSendAnnouncement;
  final bool isExportingPdf;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'إجراءات سريعة'),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: HomeActionCard(
                  icon: AppIcons.add2,
                  label: 'حملة جديدة',
                  onTap: onNewCampaign,
                ),
              ),
              SizedBox(width: Space.s),
              Expanded(
                child: HomeActionCard(
                  icon: AppIcons.announcement,
                  label: 'إرسال إعلان',
                  onTap: onSendAnnouncement,
                ),
              ),
              SizedBox(width: Space.s),
              Expanded(
                child: HomeActionCard(
                  icon: AppIcons.pdf,
                  label: isExportingPdf ? 'جارٍ التصدير…' : 'تصدير تقرير شامل',
                  onTap: onFullReport,
                  isLoading: isExportingPdf,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
