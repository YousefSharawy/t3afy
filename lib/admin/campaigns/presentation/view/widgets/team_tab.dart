import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/base/primary_widgets.dart';
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
            fontSize: FontSize.s15
          ),
        ),
        SizedBox(height: AppHeight.s16),
       
        SizedBox(height: AppHeight.s80),
      ],
    );
  }
}
