import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/core/utils/date_ar.dart';

/// Date + live line on the command band: volunteers active now and when the
/// dashboard was last refreshed successfully.
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.activeVolunteersCount,
    this.lastUpdated,
  });

  final int activeVolunteersCount;
  final DateTime? lastUpdated;

  @override
  Widget build(BuildContext context) {
    final updated = lastUpdated;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'اليوم، ${DateAr.weekdayDate(DateTime.now())}',
          style: AppText.label(color: ColorManager.onInkMuted),
        ),
        SizedBox(height: Space.vxs),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: ColorManager.sprout,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: Space.s),
            Flexible(
              child: Text(
                '$activeVolunteersCount متطوع نشيط الآن',
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.onInk,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (updated != null) ...[
              SizedBox(width: Space.s),
              Flexible(
                child: Text(
                  '· آخر تحديث ${DateAr.timeAgo(updated)}',
                  style: AppText.caption(color: ColorManager.onInkMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
