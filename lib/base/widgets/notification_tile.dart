import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/core/utils/date_ar.dart';

/// One notification row for both roles (replaces NotificationBubble and
/// AdminNotificationCard). Shows real time-ago and an icon inferred from the
/// note's wording instead of labelling every note "urgent".
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.onTap,
  });

  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final VoidCallback? onTap;

  static IconData iconFor(String title, String body) {
    final t = '$title $body';
    if (t.contains('تقرير')) return AppIcons.reports;
    if (t.contains('مهمة') || t.contains('تعيين')) return AppIcons.tasks;
    if (t.contains('حملة')) return AppIcons.campaigns;
    if (t.contains('تقييم') || t.contains('نجوم')) return AppIcons.star;
    if (t.contains('مستوى') || t.contains('ترقية')) return AppIcons.promotion;
    if (t.contains('تنبيه') || t.contains('عاجل')) return AppIcons.warning;
    return AppIcons.notification;
  }

  @override
  Widget build(BuildContext context) {
    final icon = iconFor(title, body);
    final tint = icon == AppIcons.warning
        ? ColorManager.warning
        : ColorManager.brand;
    return AppCard(
      onTap: onTap,
      color: isRead
          ? ColorManager.surface
          : ColorManager.brandSoft.withValues(alpha: 0.55),
      semanticLabel: '${isRead ? '' : 'غير مقروء، '}$title',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(icon: icon, color: tint, size: 40),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: isRead
                            ? AppText.bodyStrong()
                            : getSemiBoldStyle(
                                fontSize: FontSize.s15,
                                color: ColorManager.ink,
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: Space.s),
                    Text(DateAr.timeAgo(createdAt), style: AppText.caption()),
                    if (!isRead) ...[
                      SizedBox(width: Space.xs + 2),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ColorManager.brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                if (body.isNotEmpty) ...[
                  SizedBox(height: Space.vxs),
                  Text(
                    body,
                    style: AppText.label(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
