import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';

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
          text: const Color(0xFF4ADE80),
          label: 'جارية',
        ),
      'upcoming' => (
          bg: const Color(0xFF7C3AED).withValues(alpha: 0.15),
          text: const Color(0xFFA78BFA),
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
                    color: status.bg,
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                  ),
                  child: Text(
                    status.label,
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: status.text,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  campaign.date,
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
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
                Icon(
                  Icons.location_on_outlined,
                  size: 13.r,
                  color: Colors.pink.shade300,
                ),
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
              ],
            ),
            SizedBox(height: AppHeight.s10),
            Row(
              children: [
                _BadgeChip(
                  icon: Icons.group_outlined,
                  label: '${campaign.volunteerCount} متطوع',
                ),
                SizedBox(width: AppWidth.s8),
                _BadgeChip(
                  icon: Icons.flag_outlined,
                  label: '${campaign.targetBeneficiaries} هدف',
                  iconColor: const Color(0xFF2DD4BF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(
            icon,
            size: 11.r,
            color: iconColor ?? ColorManager.blueTwo200,
          ),
          SizedBox(width: AppWidth.s4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.blueTwo100,
            ),
          ),
        ],
      ),
    );
  }
}
