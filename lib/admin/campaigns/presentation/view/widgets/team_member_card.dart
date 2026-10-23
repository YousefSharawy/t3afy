import 'package:flutter/material.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_member_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'volunteer_picker_sheet.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    required this.durationHours,
    required this.onRemove,
  });

  final CampaignMemberEntity member;
  final double durationHours;

  /// Confirm-then-remove flow; reachable from the trailing button and by long press.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final checkedIn = member.checkedInAt?.toLocal();
    final checkedOut = member.checkedOutAt?.toLocal();
    final verified = member.verifiedHours ?? 0.0;

    return AppCard(
      onLongPress: onRemove,
      padding: EdgeInsetsDirectional.fromSTEB(Space.l, Space.vm, Space.xs, Space.vm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VolunteerAvatar(url: member.avatarUrl, size: 40),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: getMediumStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Space.vxs * 0.5),
                    Wrap(
                      spacing: Space.m,
                      children: [
                        MetaItem(
                          icon: AppIcons.star,
                          text: member.rating.toStringAsFixed(1),
                        ),
                        if ((member.region ?? '').isNotEmpty)
                          MetaItem(icon: AppIcons.location, text: member.region!),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(status: member.status, compact: true),
              IconButton(
                tooltip: 'إزالة',
                onPressed: onRemove,
                icon: const Icon(AppIcons.x, color: ColorManager.inkFaint),
              ),
            ],
          ),
          SizedBox(height: Space.vs),
          Padding(
            padding: EdgeInsetsDirectional.only(end: Space.m),
            child: checkedIn == null
                ? const MetaItem(icon: AppIcons.alarm, text: 'لم يسجل الحضور بعد')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: Space.m,
                        runSpacing: Space.vxs,
                        children: [
                          MetaItem(
                            icon: AppIcons.checkIn,
                            text: 'حضور ${DateAr.time(checkedIn)}',
                          ),
                          MetaItem(
                            icon: AppIcons.checkOut,
                            text: checkedOut == null
                                ? 'لم يسجل الانصراف'
                                : 'انصراف ${DateAr.time(checkedOut)}',
                          ),
                          MetaItem(
                            icon: AppIcons.gps,
                            text: member.isVerified
                                ? 'تم التحقق من الموقع'
                                : 'لم يتم التحقق من الموقع',
                            color: member.isVerified
                                ? ColorManager.sproutText
                                : ColorManager.warning,
                          ),
                        ],
                      ),
                      if (checkedOut != null && durationHours > 0) ...[
                        SizedBox(height: Space.vs),
                        Row(
                          children: [
                            Expanded(
                              child: StarBloomBar(value: verified / durationHours),
                            ),
                            SizedBox(width: Space.s),
                            Text(
                              '${verified.toStringAsFixed(1)} / ${durationHours.toStringAsFixed(1)} س',
                              style: getNumericStyle(
                                fontSize: FontSize.s12,
                                color: ColorManager.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
