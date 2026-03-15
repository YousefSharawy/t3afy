import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.campaign,
    this.onTap,
  });

  final TodayCampaignEntity campaign;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s12),
        padding: EdgeInsets.all(AppSize.s14),
        decoration: BoxDecoration(
          color: ColorManager.blueOne800,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: ColorManager.blueOne700),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s8,
                    vertical: AppHeight.s3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                  ),
                  child: Text(
                    'جارية',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: const Color(0xFF2DD4BF),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: AppHeight.s10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne700,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Icon(
                    Icons.home_work_rounded,
                    color: ColorManager.blueTwo200,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: AppWidth.s10),
                Expanded(
                  child: Text(
                    campaign.title,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s10),
            Row(
              children: [
                Icon(Icons.schedule_rounded,
                    size: 14.r, color: ColorManager.blueTwo200),
                SizedBox(width: AppWidth.s4),
                Text(
                  '${campaign.timeStart} - ${campaign.timeEnd}',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: ColorManager.blueTwo100,
                  ),
                ),
                SizedBox(width: AppWidth.s12),
                Icon(Icons.location_on_outlined,
                    size: 14.r, color: Colors.pink.shade300),
                SizedBox(width: AppWidth.s4),
                Expanded(
                  child: Text(
                    campaign.locationName ?? '—',
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s11,
                      color: ColorManager.blueTwo100,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppWidth.s8),
                Icon(Icons.person_outline_rounded,
                    size: 14.r, color: ColorManager.blueTwo200),
                SizedBox(width: AppWidth.s4),
                Text(
                  campaign.supervisorName ?? '—',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: ColorManager.blueTwo100,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s8,
                    vertical: AppHeight.s4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne700,
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                  ),
                  child: Text(
                    '${campaign.volunteerCount} متطوع',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: ColorManager.blueTwo100,
                    ),
                  ),
                ),
                SizedBox(width: AppWidth.s8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s8,
                    vertical: AppHeight.s4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne700,
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (campaign.targetBeneficiaries != null)
                        Text(
                          '${campaign.targetBeneficiaries} هدف',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: ColorManager.blueTwo100,
                          ),
                        )
                      else
                        Text(
                          '— هدف',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: ColorManager.blueTwo100,
                          ),
                        ),
                      SizedBox(width: AppWidth.s4),
                      Icon(Icons.check_circle_rounded,
                          size: 12.r, color: const Color(0xFF2DD4BF)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
