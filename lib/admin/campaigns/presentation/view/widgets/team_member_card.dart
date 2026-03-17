import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_member_entity.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    required this.onLongPress,
  });

  final CampaignMemberEntity member;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final statusLabel = member.status;
    final statusColor = switch (statusLabel) {
      'نشط' => const Color(0xFF4ADE80),
      'قيد المراجعة' => const Color(0xFFFBBF24),
      _ => const Color(0xFFB2B2B2),
    };

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s10),
        padding: EdgeInsets.all(AppSize.s12),
        decoration: BoxDecoration(
          color: ColorManager.blueOne800,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: AppWidth.s32,
                  height: AppHeight.s32,
                  decoration: BoxDecoration(
                    color: Color(0xff1F2E4F),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Image.asset(IconAssets.volHome),
                ),
              ],
            ),
            SizedBox(width: AppWidth.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s12,
                      color: ColorManager.white,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        IconAssets.star,
                        width: AppWidth.s12,
                        height: AppHeight.s12,
                      ),
                      SizedBox(width: AppWidth.s2),
                      Text(
                        member.rating.toStringAsFixed(1),
                        style: getSemiBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.blueOne100,
                        ),
                      ),
                      if (member.region != null) ...[
                        SizedBox(width: AppWidth.s4),
                        Image.asset(
                          IconAssets.location,
                          width: AppWidth.s12,
                          height: AppHeight.s12,
                        ),
                        SizedBox(width: AppWidth.s2),
                        Text(
                          member.region!,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: ColorManager.blueOne100,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s10,
                vertical: AppHeight.s2,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.s6),
              ),
              child: Text(
                statusLabel,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
