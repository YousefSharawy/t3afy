import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/core/utils/date_ar.dart';

class AdminReportCard extends StatelessWidget {
  const AdminReportCard({super.key, required this.report, required this.onTap});

  final AdminReportEntity report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: Space.vm),
      child: AppCard(
        onTap: onTap,
        semanticLabel: 'تقرير ${report.taskTitle} من ${report.volunteerName}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                VolunteerAvatar(
                  name: report.volunteerName,
                  url: report.volunteerAvatarUrl,
                ),
                SizedBox(width: Space.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.volunteerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong(),
                      ),
                      Text(
                        report.taskTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Space.s),
                StatusBadge(status: report.status, compact: true),
              ],
            ),
            SizedBox(height: Space.vm),
            Row(
              children: [
                RatingStars(rating: report.rating),
                const Spacer(),
                Text(DateAr.date(report.createdAt), style: AppText.caption()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Five stars; filled ones in the earned-gold token.
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size});

  final int rating;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? AppSizes.iconS;
    return Semantics(
      label: 'التقييم $rating من 5',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (i) => Icon(
            AppIcons.star,
            size: s,
            color: i < rating ? ColorManager.star : ColorManager.line,
          ),
        ),
      ),
    );
  }
}

class VolunteerAvatar extends StatelessWidget {
  const VolunteerAvatar({
    super.key,
    required this.name,
    this.url,
    this.size = 40,
  });

  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '' : name.trim().characters.first;
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: ColorManager.brandSoft,
      child: Text(
        initial,
        style: getSemiBoldStyle(
          fontSize: size * 0.4,
          color: ColorManager.brandStrong,
        ),
      ),
    );
    final px = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return ClipOval(
      child: (url == null || url!.isEmpty)
          ? fallback
          : CachedNetworkImage(
              imageUrl: url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              memCacheWidth: px,
              placeholder: (_, _) => fallback,
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}
