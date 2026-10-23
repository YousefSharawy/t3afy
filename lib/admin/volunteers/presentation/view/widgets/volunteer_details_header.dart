import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_avatar.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

/// Brand-soft hero: avatar, name, one status badge, level, rating, 3 KPIs.
class VolunteerDetailsHeader extends StatelessWidget {
  const VolunteerDetailsHeader({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final rated = details.rating.round().clamp(0, 5);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.brandSoft,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VolunteerAvatar(
                name: details.name,
                url: details.avatarUrl,
                size: 56,
                online: details.isActiveNow,
                ringColor: ColorManager.brandSoft,
              ),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.name,
                      style: getDisplayStyle(
                        fontSize: FontSize.s18,
                        color: ColorManager.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Space.vxs),
                    Row(
                      children: [
                        StatusBadge(status: details.status, compact: true),
                        SizedBox(width: Space.s),
                        Flexible(
                          child: Text(
                            'المستوى ${details.level} · ${details.levelTitle}',
                            style: AppText.label(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Space.vxs),
                    Semantics(
                      label: 'التقييم ${details.rating.toStringAsFixed(1)} من 5',
                      child: Row(
                        children: [
                          for (var i = 0; i < 5; i++)
                            Icon(
                              i < rated ? AppIcons.star : AppIcons.unstar,
                              size: AppSizes.iconS,
                              color: i < rated
                                  ? ColorManager.star
                                  : ColorManager.inkFaint,
                            ),
                          SizedBox(width: Space.xs),
                          Text(
                            details.rating.toStringAsFixed(1),
                            style: getNumericStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Space.vl),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  value: '${details.totalTasks}',
                  label: 'مهمة',
                  icon: AppIcons.done,
                  tint: ColorManager.sprout,
                ),
              ),
              SizedBox(width: Space.s),
              Expanded(
                child: StatTile(
                  value: '${details.totalHours}',
                  label: 'ساعة',
                  icon: AppIcons.hours,
                ),
              ),
              SizedBox(width: Space.s),
              Expanded(
                child: StatTile(
                  value: '${details.totalPoints}',
                  label: 'نقطة',
                  icon: AppIcons.trophy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
