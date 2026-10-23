import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

/// One card for tasks (volunteer) and campaigns (manager). Replaces TaskCard,
/// TodayTaskCard, CampaignCard and CampaignListCard. Status color comes from
/// [StatusBadge.styleOf] so badge and accent always agree.
class TaskCampaignCard extends StatelessWidget {
  const TaskCampaignCard({
    super.key,
    required this.title,
    required this.status,
    this.typeLabel,
    this.time,
    this.date,
    this.location,
    this.points,
    this.teamFilled,
    this.teamTotal,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  final String title;
  final String status;
  final String? typeLabel;
  final String? time;
  final String? date;
  final String? location;
  final int? points;

  /// Manager cards: assigned/expected volunteers → StarBloomBar.
  final int? teamFilled;
  final int? teamTotal;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final style = StatusBadge.styleOf(status);
    final meta = <Widget>[
      if (time != null && time!.isNotEmpty)
        MetaItem(icon: AppIcons.alarm, text: time!),
      if (date != null && date!.isNotEmpty)
        MetaItem(icon: AppIcons.calendar, text: date!),
      if (location != null && location!.isNotEmpty)
        MetaItem(icon: AppIcons.location, text: location!),
    ];
    return AppCard(
      onTap: onTap,
      onLongPress: onLongPress,
      accent: style.accent,
      semanticLabel: '$title، ${style.label}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (typeLabel != null && typeLabel!.isNotEmpty)
                Flexible(
                  child: Text(
                    typeLabel!,
                    style: AppText.label(color: ColorManager.brand),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                const Spacer(),
              if (typeLabel != null && typeLabel!.isNotEmpty) const Spacer(),
              StatusBadge(status: status, compact: true),
            ],
          ),
          SizedBox(height: Space.vxs),
          Text(
            title,
            style: getSemiBoldStyle(
              fontSize: FontSize.s16,
              color: ColorManager.ink,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (meta.isNotEmpty) ...[
            SizedBox(height: Space.vs),
            Wrap(spacing: Space.m, runSpacing: Space.vxs, children: meta),
          ],
          if (teamTotal != null && teamTotal! > 0) ...[
            SizedBox(height: Space.vm),
            Row(
              children: [
                Expanded(
                  child: StarBloomBar(value: (teamFilled ?? 0) / teamTotal!),
                ),
                SizedBox(width: Space.s),
                Text(
                  '${teamFilled ?? 0}/$teamTotal',
                  style: getNumericStyle(
                    fontSize: FontSize.s12,
                    color: ColorManager.inkMuted,
                  ),
                ),
              ],
            ),
          ],
          if (points != null || trailing != null) ...[
            SizedBox(height: Space.vm),
            Row(
              children: [
                if (points != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Space.s,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.starSoft,
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          AppIcons.star,
                          size: 14,
                          color: ColorManager.star,
                        ),
                        SizedBox(width: Space.xxs),
                        Text(
                          '$points نقطة',
                          style: getNumericStyle(
                            fontSize: FontSize.s12,
                            color: ColorManager.starText,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                ?trailing,
              ],
            ),
          ],
        ],
      ),
    );
  }
}
