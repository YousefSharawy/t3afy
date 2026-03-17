import 'package:flutter/material.dart';
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
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorManager.blueOne800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        title: Text(
          'إزالة المتطوع',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: Colors.white,
          ),
          textDirection: TextDirection.rtl,
        ),
        content: Text(
          'هل تريد إزالة $name من الحملة؟',
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white70,
          ),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'إلغاء',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white54,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'إزالة',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
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
        PrimaryElevatedButton(
          title: "اضافه متطوع",

          onPress: () => _showAddVolunteer(context),
          textStyle: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            color: ColorManager.white,
            fontSize: FontSize.s15
          ),
        ),
        SizedBox(height: AppHeight.s16),
        if (detail.members.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: AppHeight.s40),
              child: Text(
                'لا يوجد متطوعون معيّنون',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white.withValues(alpha: 0.4),
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
        SizedBox(height: AppHeight.s80),
      ],
    );
  }
}
