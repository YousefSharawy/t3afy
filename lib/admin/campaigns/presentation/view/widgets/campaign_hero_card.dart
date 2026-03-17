import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
        bg: const Color(0xFFF59E0B).withValues(alpha: 0.15),
        text: const Color(0xFFFBBF24),
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
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppWidth.s48,
            height: AppHeight.s48,
            decoration: BoxDecoration(
              color: Color(0xff306CFE).withValues(alpha: 0.33),
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Image.asset(
              IconAssets.camp,
              width: AppWidth.s36,
              height: AppHeight.s36,
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
                          fontSize: FontSize.s16,
                          color: ColorManager.blueOne50,
                        ),
                      ),
                    ),
                    SizedBox(width: AppWidth.s8),
                   
                  ],
                ),
                SizedBox(height: AppHeight.s6),
                Row(
                  children: [
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
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: status.text,
                        ),
                      ),
                    ),
                    SizedBox(width: AppWidth.s8,),
                   Image.asset(IconAssets.calendar),
                    SizedBox(width: AppWidth.s4),
                    Text(
                      detail.date,
                      style: getLightStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s10,
                        color: ColorManager.white,
                      ),
                    ),
                    // if (detail.timeStart != null) ...[
                    //   SizedBox(width: AppWidth.s8),
                    //   // Icon(
                    //   //   Icons.schedule_rounded,
                    //   //   size: 12.r,
                    //   //   color: Colors.white.withValues(alpha: 0.5),
                    //   // ),
                    //   // SizedBox(width: AppWidth.s4),
                    //   // Text(
                    //   //   '${detail.timeStart} - ${detail.timeEnd ?? ''}',
                    //   //   style: getRegularStyle(
                    //   //     fontFamily: FontConstants.fontFamily,
                    //   //     fontSize: FontSize.s11,
                    //   //     color: Colors.white.withValues(alpha: 0.5),
                    //   //   ),
                    //   // ),
                    // ],
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
