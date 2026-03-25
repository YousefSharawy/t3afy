import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

class CampaignHeroCard extends StatelessWidget {
  const CampaignHeroCard({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppWidth.s16),
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppWidth.s48,
            height: AppHeight.s48,
            decoration: BoxDecoration(
              color: ColorManager.accentSand,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Image.asset(
              IconAssets.camp,
            ),
          ),
          SizedBox(width: AppWidth.s16),
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
                          color: ColorManager.natural900,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppHeight.s4),
                Row(
                  children: [
                    StatusBadge(status: detail.status),
                    SizedBox(width: AppWidth.s8),
                    Image.asset(IconAssets.calendar),
                    SizedBox(width: AppWidth.s4),
                    Text(
                      detail.date,
                      style: getLightStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s10,
                        color: ColorManager.natural400,
                      ),
                    ),
                  ],
                ),
                if (detail.type.isNotEmpty) ...[
                  SizedBox(height: AppHeight.s4),
                  Row(
                    children: [
                      Icon(
                        taskTypeIcon(detail.type),
                        size: 12,
                        color: ColorManager.natural400,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        detail.type,
                        style: getLightStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.natural400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
