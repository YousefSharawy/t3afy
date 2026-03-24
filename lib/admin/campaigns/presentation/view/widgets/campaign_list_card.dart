import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'badge_chip.dart';

class CampaignListCard extends StatelessWidget {
  const CampaignListCard({
    super.key,
    required this.campaign,
    required this.onTap,
  });

  final CampaignEntity campaign;
  final VoidCallback onTap;

  static const _arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  static String _formatDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      return '${d.day} ${_arabicMonths[d.month - 1]} ${d.year}';
    } catch (_) {
      return raw;
    }
  }

  static Color _topBorderColor(String status) {
    return switch (status) {
      'active' || 'ongoing' => ColorManager.info,
      'upcoming'            => ColorManager.warning,
      'done'                => ColorManager.success,
      'missed'              => ColorManager.error,
      'paused'              => ColorManager.warning,
      _                     => ColorManager.natural400,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: BorderDirectional(
            top: BorderSide(color: _topBorderColor(campaign.status), width: 3.w),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
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
                        fontSize: FontSize.s14,
                        color: ColorManager.natural700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: campaign.status),
                ],
              ),
              SizedBox(height: AppHeight.s8),
              Row(
                children: [
                  Image.asset(IconAssets.calendar, width: AppWidth.s16, height: AppHeight.s16),
                  SizedBox(width: AppWidth.s4),
                  Text(
                    _formatDate(campaign.date),
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: ColorManager.natural300,
                    ),
                  ),
                  SizedBox(width: AppWidth.s4),
                  Image.asset(IconAssets.location, width: AppWidth.s16, height: AppHeight.s16),
                  SizedBox(width: AppWidth.s4),
                  Expanded(
                    child: Text(
                      campaign.locationName ?? '—',
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s10,
                        color: ColorManager.natural400,
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
                    label: '${campaign.volunteerCount} متطوع',
                  ),
                  SizedBox(width: AppWidth.s6),
                  BadgeChip(
                    label: '${campaign.targetBeneficiaries} هدف',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
