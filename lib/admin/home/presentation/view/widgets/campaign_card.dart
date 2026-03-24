import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/admin/home/domain/entities/today_campaign_entity.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({super.key, required this.campaign, this.onTap});
  final TodayCampaignEntity campaign;
  final VoidCallback? onTap;
  Color get _statusTextColor {
    switch (campaign.status) {
      case 'ongoing':
      case 'active':
        return ColorManager.info;
      case 'upcoming':
        return ColorManager.warning;
      case 'completed':
      case 'done':
        return ColorManager.success;
      case 'missed':
        return ColorManager.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.all(AppSize.s12),
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: BorderDirectional(top: BorderSide(color: _statusTextColor,width: 3.sp)),
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.sp),
                        decoration: BoxDecoration(
                          color: ColorManager.accentSand,
                          borderRadius: BorderRadius.circular(AppRadius.s8),
                        ),
                        child: Image.asset(IconAssets.camp),
                      ),
                      SizedBox(width: AppWidth.s11),
                      Expanded(
                        child: Text(
                          campaign.title,
                          style: getBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.natural700,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.s4),
                  Row(
                    children: [
                      Image.asset(
                        IconAssets.calendar,
                        width: AppWidth.s16,
                        height: AppHeight.s16,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        '${campaign.timeStart} - ${campaign.timeEnd}',
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.natural400,
                        ),
                      ),
                      SizedBox(width: AppWidth.s4),
                      Image.asset(
                        IconAssets.location,
                        width: AppWidth.s16,
                        height: AppHeight.s16,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Expanded(
                        child: Text(
                          campaign.locationName ?? '—',
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: ColorManager.natural300,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.s13),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppWidth.s8,
                          vertical: AppHeight.s2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.primary50,
                          border: Border.all(
                            width: 0.5.sp,
                            color: ColorManager.primary500,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.s6),
                        ),
                        child: Text(
                          '${campaign.volunteerCount} متطوع',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: ColorManager.primary500,
                          ),
                        ),
                      ),
                      SizedBox(width: AppWidth.s8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppWidth.s8,
                          vertical: AppHeight.s2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.primary50,
                          border: Border.all(
                            width: 0.5.sp,
                            color: ColorManager.primary500,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.s6),
                        ),
                        child: Text(
                          campaign.targetBeneficiaries != null
                              ? '${campaign.targetBeneficiaries} هدف'
                              : '— هدف',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: ColorManager.primary500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: AppWidth.s8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(status: campaign.status),
                SizedBox(height: AppHeight.s4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
