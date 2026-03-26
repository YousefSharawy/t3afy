import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_member_entity.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

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

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s10),
        padding: EdgeInsets.all(AppSize.s12),
        decoration: BoxDecoration(
          color: ColorManager.white,
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
                    color: ColorManager.primary50,
                    border: Border.all(width: 0.5.sp,color: ColorManager.primary500),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Image.asset(IconAssets.vol2),
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
                      color: ColorManager.natural900,
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
                          color: ColorManager.natural400,
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
                            color: ColorManager.natural400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(status: member.status),
                SizedBox(height: AppHeight.s4),
                _AttendanceDot(member: member),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceDot extends StatelessWidget {
  const _AttendanceDot({required this.member});
  final CampaignMemberEntity member;

  @override
  Widget build(BuildContext context) {
    if (member.checkedOutAt != null) {
      // Checked out
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline,
              size: 11.r, color: ColorManager.success),
          SizedBox(width: 3.w),
          Text(
            'حضر ${member.verifiedHours?.toStringAsFixed(1) ?? '0'} س',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s9,
              color: ColorManager.success,
            ),
          ),
        ],
      );
    }
    if (member.checkedInAt != null) {
      // Live — checked in
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: const BoxDecoration(
              color: ColorManager.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'متواجد الآن',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s9,
              color: ColorManager.success,
            ),
          ),
        ],
      );
    }
    // Not checked in
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.w,
          height: 7.w,
          decoration: const BoxDecoration(
            color: ColorManager.natural300,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          'لم يحضر بعد',
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s9,
            color: ColorManager.natural400,
          ),
        ),
      ],
    );
  }
}
