import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/section_label.dart';
import 'team_member_card.dart';
import 'add_volunteer_sheet.dart';

class TeamTab extends StatelessWidget {
  const TeamTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  Future<void> _showAddVolunteer(BuildContext context) async {
    final cubit = context.read<CampaignDetailCubit>();
    final volunteers = await cubit.getUnassignedVolunteers(detail.id);
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddVolunteerSheet(taskId: detail.id, volunteers: volunteers),
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    String userId,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManager.natural50,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s20),
          ),
          title: Text(
            'إزالة المتطوع',
            style: getSemiBoldStyle(
              color: ColorManager.natural900,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'هل تريد إزالة $name من الحملة؟',
            style: getRegularStyle(
              color: ColorManager.natural900.withValues(alpha: 0.7),
              fontSize: FontSize.s14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'إلغاء',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.natural900.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.error,
                foregroundColor: ColorManager.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s30),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(ctx, true);
              },
              child: Text(
                'إزالة',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<CampaignDetailCubit>().removeVolunteer(
        taskId: detail.id,
        userId: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSize.s16),
      children: [
        // ── Attendance summary card ──────────────────────────────────
        if (detail.members.isNotEmpty) ...[
          _AttendanceSummaryCard(detail: detail),
          SizedBox(height: AppHeight.s12),
        ],

        // ── Member cards ─────────────────────────────────────────────
        if (detail.members.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppHeight.s40),
              child: Text(
                'لا يوجد متطوعون معيّنون',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.natural400,
                ),
              ),
            ),
          )
        else
          ...detail.members.map(
            (m) => TeamMemberCard(
              member: m,
              durationHours: detail.durationHours,
              onLongPress: () => _confirmRemove(context, m.id, m.name),
            ),
          ),

        PrimaryElevatedButton(
          title: "اضافه متطوع",
          onPress: () {
            HapticFeedback.mediumImpact();
            _showAddVolunteer(context);
          },
          textStyle: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.white,
            fontSize: FontSize.s15,
          ),
        ),
        SizedBox(height: AppHeight.s16),
        SizedBox(height: AppHeight.s80),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Attendance summary card
// ─────────────────────────────────────────────────────────────────────────────

class _AttendanceSummaryCard extends StatelessWidget {
  const _AttendanceSummaryCard({required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final total = detail.members.length;
    final attended = detail.verifiedAttendanceCount;
    final rate = detail.attendanceRate;
    final hours = detail.totalVerifiedHours;

    final rateColor = rate >= 50 ? ColorManager.success : ColorManager.warning;

    return Container(
      padding: EdgeInsets.all(AppSize.s12),
      decoration: BoxDecoration(
        color: ColorManager.natural100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'ملخص الحضور'),
          SizedBox(height: AppHeight.s10),

          // ── Stats row ────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _SummaryStatBox(
                  value: '$attended / $total',
                  label: 'حضروا',
                  valueColor: rateColor,
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: _SummaryStatBox(
                  value: '${rate.toStringAsFixed(0)}٪',
                  label: 'معدل الحضور',
                  valueColor: rateColor,
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: _SummaryStatBox(
                  value: hours.toStringAsFixed(1),
                  label: 'ساعات مؤكدة',
                  valueColor: ColorManager.primary500,
                ),
              ),
            ],
          ),

          SizedBox(height: AppHeight.s10),

          // ── Progress bar ─────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s8),
            child: LinearProgressIndicator(
              value: total > 0 ? attended / total : 0,
              minHeight: 6.h,
              backgroundColor: ColorManager.natural200,
              valueColor: AlwaysStoppedAnimation<Color>(rateColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatBox extends StatelessWidget {
  const _SummaryStatBox({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s8,
        horizontal: AppWidth.s4,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.natural400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
