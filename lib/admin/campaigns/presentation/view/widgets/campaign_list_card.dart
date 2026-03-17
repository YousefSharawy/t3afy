import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';
import 'badge_chip.dart';

class CampaignListCard extends StatelessWidget {
  const CampaignListCard({
    super.key,
    required this.campaign,
    required this.onTap,
  });

  final CampaignEntity campaign;
  final VoidCallback onTap;

  static ({Color bg, Color text, String label}) _statusInfo(String status) {
    return switch (status) {
      'active' || 'ongoing' => (
        bg: const Color(0xFF16A34A).withValues(alpha: 0.15),
        text: ColorManager.successLight,
        label: 'جارية',
      ),
      'upcoming' => (
        bg: ColorManager.violet700.withValues(alpha: 0.15),
        text: ColorManager.violet300,
        label: 'قادمة',
      ),
      'done' => (
        bg: Colors.grey.withValues(alpha: 0.15),
        text: Colors.grey,
        label: 'مكتملة',
      ),
      'paused' => (
        bg: Colors.orange.withValues(alpha: 0.15),
        text: Colors.orange,
        label: 'موقوفة',
      ),
      _ => (
        bg: ColorManager.blueOne700,
        text: ColorManager.blueTwo200,
        label: status,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusInfo(campaign.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: ColorManager.blueOne800,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(6.sp),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne700,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Image.asset(IconAssets.camp),
                ),
                SizedBox(width: AppWidth.s17),
                Text(
                  campaign.title,
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s13,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s8,
                    vertical: AppHeight.s3,
                  ),
                  decoration: BoxDecoration(
                    color: status.bg,
                    borderRadius: BorderRadius.circular(AppRadius.s6),
                  ),
                  child: Text(
                    status.label,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: status.text,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s4),
            SizedBox(height: AppHeight.s6),
            Row(
              children: [
                Image.asset(IconAssets.calendar),
                SizedBox(width: AppWidth.s4),
                Text(
                  campaign.date,
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: ColorManager.blueOne300,
                  ),
                ),
                SizedBox(width: AppWidth.s4),
                Image.asset(IconAssets.location),
                SizedBox(width: AppWidth.s4),
                Expanded(
                  child: Text(
                    campaign.locationName ?? '—',
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: ColorManager.blueOne300,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s8),
            Row(
              children: [
                BadgeChip(
                  icon: IconAssets.group,
                  label: '${campaign.volunteerCount} متطوع',
                ),
                SizedBox(width: AppWidth.s6),
                BadgeChip(
                  icon: IconAssets.target,
                  label: '${campaign.targetBeneficiaries} هدف',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
