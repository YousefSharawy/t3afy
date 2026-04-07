import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/ui_utiles.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_member_entity.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    required this.durationHours,
    required this.onLongPress,
  });

  final CampaignMemberEntity member;
  final double durationHours;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: AppWidth.s32,
                  height: AppHeight.s32,
                  decoration: BoxDecoration(
                    color: ColorManager.primary50,
                    border: Border.all(
                      width: 0.5.sp,
                      color: ColorManager.primary500,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Image.asset(IconAssets.vol2),
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

            // ── Attendance details (only if checked in) ─────────────
            if (member.checkedInAt != null) ...[
              Divider(
                height: AppHeight.s16,
                thickness: 0.5,
                color: ColorManager.natural200,
              ),
              _AttendanceDetails(member: member, durationHours: durationHours),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Attendance dot (top-right corner of the header row)
// ─────────────────────────────────────────────────────────────────────────────

class _AttendanceDot extends StatelessWidget {
  const _AttendanceDot({required this.member});
  final CampaignMemberEntity member;

  @override
  Widget build(BuildContext context) {
    if (member.checkedOutAt != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 11.r,
            color: ColorManager.success,
          ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Expanded attendance details section (shown only if checkedInAt != null)
// ─────────────────────────────────────────────────────────────────────────────

class _AttendanceDetails extends StatelessWidget {
  const _AttendanceDetails({required this.member, required this.durationHours});

  final CampaignMemberEntity member;
  final double durationHours;

  @override
  Widget build(BuildContext context) {
    final checkedIn = member.checkedInAt;
    final checkedOut = member.checkedOutAt;
    final verified = member.verifiedHours ?? 0.0;
    final hasLat = member.checkInLat != null && member.checkInLng != null;

    return Padding(
      padding: EdgeInsetsDirectional.only(top: AppHeight.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Check-in time ────────────────────────────────────────
          _TimeRow(
            label: 'وقت الحضور:',
            value: formatTimeArabic(checkedIn),
            icon: IconAssets.alarm,
          ),

          // ── Check-out time ───────────────────────────────────────
          if (checkedOut != null)
            _TimeRow(
              label: 'وقت الانصراف:',
              value: formatTimeArabic(checkedOut),
              icon: IconAssets.alarm,
            )
          else
            Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s6),
              child: Text(
                'لم يسجل الانصراف بعد',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.natural400,
                ),
              ),
            ),

          // ── Verified hours + comparison ──────────────────────────
          if (checkedOut != null) ...[
            SizedBox(height: AppHeight.s4),
            Row(
              children: [
                Image.asset(
                  IconAssets.hours,
                  width: AppWidth.s14,
                  height: AppHeight.s14,
                ),
                SizedBox(width: AppWidth.s4),
                Text(
                  'المدة الفعلية: ',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: ColorManager.natural500,
                  ),
                ),
                Text(
                  '${verified.toStringAsFixed(1)} ساعات',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: ColorManager.primary500,
                  ),
                ),
                SizedBox(width: AppWidth.s6),
                if (durationHours > 0)
                  _HoursComparisonBadge(
                    verified: verified,
                    expected: durationHours,
                  ),
              ],
            ),
            SizedBox(height: AppHeight.s6),
          ],

          // ── GPS verification badge ───────────────────────────────
          Row(
            children: [
              if (member.isVerified)
                _InlineBadge(
                  label: 'تم التحقق من الموقع 📍',
                  textColor: ColorManager.success,
                  bgColor: ColorManager.successLight,
                  borderColor: ColorManager.success,
                )
              else
                _InlineBadge(
                  label: 'لم يتم التحقق',
                  textColor: ColorManager.warning,
                  bgColor: ColorManager.warningLight,
                  borderColor: ColorManager.warning,
                ),
            ],
          ),

          // ── Check-in location coords ─────────────────────────────
          if (hasLat) ...[
            SizedBox(height: AppHeight.s6),
            Row(
              children: [
                Icon(
                  Icons.pin_drop_outlined,
                  size: 11.r,
                  color: ColorManager.natural400,
                ),
                SizedBox(width: 3.w),
                Text(
                  'موقع الحضور: ${member.checkInLat!.toStringAsFixed(3)}, ${member.checkInLng!.toStringAsFixed(3)}',
                  style: getRegularStyle(
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
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s6),
      child: Row(
        children: [
          Image.asset(icon, width: AppWidth.s14, height: AppHeight.s14),
          SizedBox(width: AppWidth.s4),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s11,
              color: ColorManager.natural500,
            ),
          ),
          SizedBox(width: AppWidth.s4),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s11,
              color: ColorManager.natural700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoursComparisonBadge extends StatelessWidget {
  const _HoursComparisonBadge({required this.verified, required this.expected});

  final double verified;
  final double expected;

  @override
  Widget build(BuildContext context) {
    final isComplete = verified >= expected;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s6,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: isComplete
            ? ColorManager.successLight
            : ColorManager.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(
          color: isComplete ? ColorManager.success : ColorManager.warning,
          width: 0.5.sp,
        ),
      ),
      child: Text(
        isComplete ? 'مكتمل ✓' : 'أقل من المتوقع',
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s9,
          color: isComplete ? ColorManager.success : ColorManager.warning,
        ),
      ),
    );
  }
}

class _InlineBadge extends StatelessWidget {
  const _InlineBadge({
    required this.label,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
  });

  final String label;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s8,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: borderColor, width: 0.5.sp),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s10,
          color: textColor,
        ),
      ),
    );
  }
}
