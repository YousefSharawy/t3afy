import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
          child: Row(
            children: [
              Icon(
                Icons.campaign_rounded,
                color: ColorManager.blueTwo200,
                size: 20.r,
              ),
              SizedBox(width: AppWidth.s6),
              Text(
                'حملات اليوم',
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s16,
                  color: Colors.white,
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
                    color: ColorManager.blueThree900,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppHeight.s12),
        if (campaigns.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
            child: Text(
              'لا توجد حملات اليوم',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.blueTwo200,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
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
