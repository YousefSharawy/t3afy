import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';

import 'check_in_card_shell.dart';

/// Checked out — the finished-shift summary. When [celebrate] is true (the
/// volunteer just checked out on this screen) the ring fills and blooms into
/// the star once; a restored summary shows the bloomed star at rest.
class CheckedOutCard extends StatelessWidget {
  const CheckedOutCard({
    super.key,
    required this.state,
    this.celebrate = false,
  });

  final LocationCheckedOut state;
  final bool celebrate;

  @override
  Widget build(BuildContext context) {
    final minutes = (state.verifiedHours * 60).round();
    return CheckInCardShell(
      icon: AppIcons.done,
      tone: ColorManager.sprout,
      title: 'تم تسجيل الحضور والانصراف',
      trailing: const _VerifiedChip(),
      children: [
        SizedBox(height: Space.vm),
        Row(
          children: [
            celebrate
                ? TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: AppMotion.of(context, AppMotion.slow * 2),
                    curve: AppMotion.enter,
                    builder: (_, v, _) => StarBloomProgress(value: v),
                  )
                : const StarBloomProgress(value: 1),
            SizedBox(width: Space.l),
            Expanded(
              child: Column(
                children: [
                  CheckInSummaryRow(
                    label: 'وقت الحضور',
                    value: DateAr.time(state.checkedInAt.toLocal()),
                  ),
                  CheckInSummaryRow(
                    label: 'وقت الانصراف',
                    value: DateAr.time(state.checkedOutAt.toLocal()),
                  ),
                  CheckInSummaryRow(
                    label: 'المدة الفعلية',
                    value: DateAr.duration(Duration(minutes: minutes)),
                    strong: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Space.s, vertical: Space.vxs),
      decoration: BoxDecoration(
        color: ColorManager.sproutSoft,
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.commit, size: 14, color: ColorManager.sproutText),
          SizedBox(width: Space.xs),
          Text(
            'تم التحقق',
            style: AppText.caption(color: ColorManager.sproutText),
          ),
        ],
      ),
    );
  }
}
