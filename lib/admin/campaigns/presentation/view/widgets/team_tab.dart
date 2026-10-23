import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';
import 'team_member_card.dart';
import 'volunteer_picker_sheet.dart';

class TeamTab extends StatelessWidget {
  const TeamTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  Future<void> _showAddVolunteer(BuildContext context) async {
    final cubit = context.read<CampaignDetailCubit>();
    final volunteers = await cubit.getUnassignedVolunteers(detail.id);
    if (!context.mounted) return;
    await VolunteerPickerSheet.show(
      context,
      volunteers: volunteers,
      confirmLabel: 'تعيين',
      onRefresh: () => cubit.getUnassignedVolunteers(detail.id),
      onConfirm: (ids) async {
        if (ids.isEmpty) return true;
        final ok = await cubit.assignVolunteers(
          taskId: detail.id,
          userIds: ids.toList(),
          adminId: LocalAppStorage.getUserId() ?? '',
        );
        // Failures are toasted by the detail screen's listener.
        if (ok && context.mounted) {
          Toast.success.show(context, title: 'تم تعيين ${ids.length} متطوع بنجاح');
        }
        return ok;
      },
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    String userId,
    String name,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'إزالة المتطوع',
      body: 'هل تريد إزالة $name من الحملة؟',
      confirmLabel: 'إزالة',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<CampaignDetailCubit>().removeVolunteer(
        taskId: detail.id,
        userId: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = detail.members;
    final total = members.length;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.vl,
        Space.gutter,
        Space.vxl + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        if (members.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: StatTile(
                  value: '${detail.verifiedAttendanceCount}/$total',
                  label: 'حضور مؤكد',
                  icon: AppIcons.done,
                  tint: ColorManager.sprout,
                ),
              ),
              SizedBox(width: Space.s),
              Expanded(
                child: StatTile(
                  value: '${detail.attendanceRate.toStringAsFixed(0)}%',
                  label: 'معدل الحضور',
                  icon: AppIcons.performance,
                ),
              ),
              SizedBox(width: Space.s),
              Expanded(
                child: StatTile(
                  value: detail.totalVerifiedHours.toStringAsFixed(1),
                  label: 'ساعات مؤكدة',
                  icon: AppIcons.hours,
                  tint: ColorManager.info,
                ),
              ),
            ],
          ),
          SizedBox(height: Space.vl),
          for (final m in members) ...[
            TeamMemberCard(
              key: ValueKey(m.id),
              member: m,
              durationHours: detail.durationHours,
              onRemove: () => _confirmRemove(context, m.id, m.name),
            ),
            SizedBox(height: Space.vm),
          ],
          SizedBox(height: Space.vs),
          PrimaryElevatedButton(
            title: 'إضافة متطوع',
            icon: AppIcons.add3,
            onPress: () => _showAddVolunteer(context),
          ),
        ] else
          AppEmptyState(
            title: 'لا يوجد متطوعون معيّنون',
            message: 'عيّن فريق هذه الحملة',
            icon: AppIcons.group,
            actionLabel: 'إضافة متطوع',
            onAction: () => _showAddVolunteer(context),
          ),
      ],
    );
  }
}
