import 'package:flutter/material.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/core/utils/date_ar.dart';

/// Brand hero at the top of the campaign detail: type, title, status, when and
/// where, plus the team attendance ring (checked-in / assigned).
class CampaignHeroCard extends StatelessWidget {
  const CampaignHeroCard({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(detail.date);
    final time = DateAr.timeRange(detail.timeStart, detail.timeEnd);
    final team = detail.members.length;
    final attended = detail.members.where((m) => m.attended).length;

    return Container(
      padding: EdgeInsets.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.brandSoft,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (detail.type.isNotEmpty) ...[
                      Icon(
                        taskTypeIcon(detail.type),
                        size: AppSizes.iconS,
                        color: ColorManager.brand,
                      ),
                      SizedBox(width: Space.xs),
                      Flexible(
                        child: Text(
                          detail.type,
                          style: AppText.label(color: ColorManager.brandStrong),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: Space.s),
                    ],
                    StatusBadge(status: detail.status, compact: true),
                  ],
                ),
                SizedBox(height: Space.vs),
                Text(
                  detail.title,
                  style: getDisplayStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.ink,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Space.vs),
                Wrap(
                  spacing: Space.m,
                  runSpacing: Space.vxs,
                  children: [
                    MetaItem(
                      icon: AppIcons.calendar,
                      text: date == null ? detail.date : DateAr.weekdayDate(date),
                    ),
                    if (time.isNotEmpty) MetaItem(icon: AppIcons.alarm, text: time),
                    if ((detail.locationName ?? '').isNotEmpty)
                      MetaItem(
                        icon: AppIcons.location,
                        text: detail.locationName!,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (team > 0) ...[
            SizedBox(width: Space.m),
            Column(
              children: [
                StarBloomProgress(
                  value: attended / team,
                  trackColor: ColorManager.surface,
                ),
                SizedBox(height: Space.vxs),
                Text(
                  '$attended/$team حضروا',
                  style: getNumericStyle(
                    fontSize: FontSize.s11,
                    color: ColorManager.inkMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
