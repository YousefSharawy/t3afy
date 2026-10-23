import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/task_campaign_card.dart';
import 'package:t3afy/core/utils/date_ar.dart';

class TodayCampaignsSection extends StatelessWidget {
  const TodayCampaignsSection({
    super.key,
    required this.campaigns,
    this.onViewAll,
    this.onCampaignTap,
    this.onNewCampaign,
  });

  final List<TodayCampaignEntity> campaigns;
  final VoidCallback? onViewAll;
  final void Function(TodayCampaignEntity)? onCampaignTap;
  final VoidCallback? onNewCampaign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'حملات اليوم',
          actionLabel: 'عرض الكل',
          onAction: onViewAll,
        ),
        if (campaigns.isEmpty)
          AppCard(
            padding: EdgeInsets.zero,
            child: AppEmptyState(
              compact: true,
              icon: AppIcons.camp,
              title: 'لا توجد حملات اليوم',
              actionLabel: 'حملة جديدة',
              onAction: onNewCampaign,
            ),
          )
        else
          for (final c in campaigns)
            Padding(
              key: ValueKey(c.id),
              padding: EdgeInsets.only(bottom: Space.vm),
              child: TaskCampaignCard(
                title: c.title,
                status: c.status,
                typeLabel: c.type,
                time: DateAr.timeRange(c.timeStart, c.timeEnd),
                location: c.locationName,
                teamFilled: c.completedCount,
                teamTotal: c.volunteerCount,
                onTap: () => onCampaignTap?.call(c),
              ),
            ),
      ],
    );
  }
}
