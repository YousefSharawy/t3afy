import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'home_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.onNewCampaign,
    this.onFullReport,
    this.onSendAnnouncement,
  });

  final VoidCallback? onNewCampaign;
  final VoidCallback? onFullReport;
  final VoidCallback? onSendAnnouncement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(IconAssets.fast, width: AppWidth.s24, height: AppHeight.s24),
            Text(
              'اجراءات سريعة',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural900,
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          children: [
           
            HomeActionCard(
              icon: IconAssets.add2,
              label: 'حملة جديدة',
              onTap: onNewCampaign,
            ),
            SizedBox(width: AppWidth.s8),
             HomeActionCard(
              icon: IconAssets.announcement,
              label: 'إرسال إعلان',
              onTap: onSendAnnouncement,
            ),
          ],
        ),
      ],
    );
  }
}
