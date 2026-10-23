import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_avatar.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

class VolunteerCard extends StatelessWidget {
  const VolunteerCard({super.key, required this.volunteer, required this.onTap});

  final AdminVolunteerEntity volunteer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final v = volunteer;
    final hasRating = v.rating > 0;
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(Space.m),
      semanticLabel: v.name,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VolunteerAvatar(
            name: v.name,
            url: v.avatarUrl,
            size: AppSizes.touch,
            online: v.isActiveNow,
          ),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        v.name,
                        style: AppText.bodyStrong(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: Space.s),
                    StatusBadge(status: v.status, compact: true),
                  ],
                ),
                SizedBox(height: Space.vxs),
                Row(
                  children: [
                    Flexible(
                      child: MetaItem(
                        icon: AppIcons.location,
                        text: v.region ?? 'غير محدد',
                      ),
                    ),
                    if (v.level != null) ...[
                      SizedBox(width: Space.m),
                      Flexible(
                        child: MetaItem(
                          icon: AppIcons.medal,
                          text: 'المستوى ${v.level}',
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: Space.vxs),
                Row(
                  children: [
                    Flexible(
                      child: MetaItem(
                        icon: AppIcons.done,
                        text: '${v.totalTasks} مهمة',
                      ),
                    ),
                    SizedBox(width: Space.m),
                    Flexible(
                      child: MetaItem(
                        icon: AppIcons.hours,
                        text: '${v.totalHours} ساعة',
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      hasRating ? AppIcons.star : AppIcons.unstar,
                      size: AppSizes.iconS,
                      color: hasRating
                          ? ColorManager.star
                          : ColorManager.inkFaint,
                    ),
                    SizedBox(width: Space.xxs),
                    Text(
                      v.rating.toStringAsFixed(1),
                      style: getNumericStyle(
                        fontSize: FontSize.s13,
                        color: ColorManager.inkMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
