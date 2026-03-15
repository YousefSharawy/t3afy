import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isActive = member.isActive;
    final statusColor = isActive
        ? const Color(0xFF4ADE80)
        : const Color(0xFFFBBF24);
    final statusLabel = isActive ? 'نشط' : 'قيد المراجعة';

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s10),
        padding: EdgeInsets.all(AppSize.s12),
        decoration: BoxDecoration(
          color: ColorManager.blueOne800,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: ColorManager.blueOne700),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: ColorManager.blueOne700,
              backgroundImage: member.avatarUrl != null
                  ? NetworkImage(member.avatarUrl!)
                  : null,
              child: member.avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: ColorManager.blueTwo200,
                      size: 22.r,
                    )
                  : null,
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
                      fontSize: FontSize.s13,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppHeight.s4),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 13.r,
                        color: const Color(0xFFFBBF24),
                      ),
                      SizedBox(width: AppWidth.s2),
                      Text(
                        member.rating.toStringAsFixed(1),
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s11,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      if (member.region != null) ...[
                        SizedBox(width: AppWidth.s8),
                        Icon(
                          Icons.location_on_outlined,
                          size: 11.r,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        SizedBox(width: AppWidth.s2),
                        Text(
                          member.region!,
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s11,
                            color: Colors.white.withValues(alpha: 0.4),
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
                horizontal: AppWidth.s8,
                vertical: AppHeight.s4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.s20),
              ),
              child: Text(
                statusLabel,
                style: getMediumStyle(
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
