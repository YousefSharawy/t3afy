import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/campaign_card.dart';

class TodayCampaignsSection extends StatelessWidget {
  const TodayCampaignsSection({
    super.key,
    required this.campaigns,
    this.onViewAll,
    this.onCampaignTap,
  });

  final List<TodayCampaignEntity> campaigns;
  final VoidCallback? onViewAll;
  final void Function(TodayCampaignEntity)? onCampaignTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
           Image.asset(IconAssets.reports),
            SizedBox(width: AppWidth.s8),
            Text(
              'حملات اليوم',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural900,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'عرض الكل',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.natural600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        if (campaigns.isEmpty)
          Center(
            child: Text(
              'لا توجد حملات اليوم',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural500,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: campaigns.length,
            itemBuilder: (context, i) => CampaignCard(
              campaign: campaigns[i],
              onTap: () => onCampaignTap?.call(campaigns[i]),
            ),
          ),
      ],
    );
  }
}
