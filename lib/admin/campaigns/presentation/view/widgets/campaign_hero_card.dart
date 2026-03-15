import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';

class CampaignHeroCard extends StatelessWidget {
  const CampaignHeroCard({super.key, required this.detail});

  final CampaignDetailEntity detail;

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
    final status = _statusInfo(detail.status);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppWidth.s16),
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.blueOne800,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: ColorManager.blueOne700),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: ColorManager.blueOne700,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Icon(
              Icons.home_work_rounded,
              color: const Color(0xFF00ABD2),
              size: 28.r,
            ),
          ),
          SizedBox(width: AppWidth.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        detail.title,
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: AppWidth.s8),
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
                  ],
                ),
                SizedBox(height: AppHeight.s6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12.r,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    SizedBox(width: AppWidth.s4),
                    Text(
                      detail.date,
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    if (detail.timeStart != null) ...[
                      SizedBox(width: AppWidth.s8),
                      Icon(
                        Icons.schedule_rounded,
                        size: 12.r,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        '${detail.timeStart} - ${detail.timeEnd ?? ''}',
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s11,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
