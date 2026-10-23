import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/assign_task_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/edit_rating_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/edit_volunteer_data_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/send_message_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/upgrade_level_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'delete_button.dart';
import 'volunteer_action_row.dart';

/// Actions for the volunteer. Navigation after delete / suspend / approve /
/// reject is handled once, in VolunteerDetailsView.
class VolunteerManageTab extends StatefulWidget {
  const VolunteerManageTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<VolunteerManageTab> createState() => _VolunteerManageTabState();
}

class _VolunteerManageTabState extends State<VolunteerManageTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  VolunteerDetailsEntity get details => widget.details;

  EdgeInsets get _padding => EdgeInsets.only(
    top: Space.vs,
    bottom: Space.vxl + MediaQuery.paddingOf(context).bottom,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return details.role == 'user'
        ? _buildPendingActions(context)
        : _buildVolunteerActions(context);
  }

  Widget _buildPendingActions(BuildContext context) {
    return ListView(
      padding: _padding,
      children: [
        _PendingApproveButton(volunteerId: details.id, name: details.name),
        SizedBox(height: Space.vm),
        _RejectButton(volunteerId: details.id, name: details.name),
      ],
    );
  }

  Widget _buildVolunteerActions(BuildContext context) {
    return ListView(
      padding: _padding,
      children: [
        VolunteerActionRow(
          icon: AppIcons.reports,
          label: 'تعيين مهمة جديدة',
          onTap: () => _open(context, const AssignTaskSheet()),
        ),
        VolunteerActionRow(
          icon: AppIcons.message,
          label: 'إرسال رسالة مباشرة',
          onTap: () => _open(context, const SendMessageSheet()),
        ),
        VolunteerActionRow(
          icon: AppIcons.star,
          label: 'تعديل التقييم',
          onTap: () =>
              _open(context, EditRatingSheet(currentRating: details.rating)),
        ),
        VolunteerActionRow(
          icon: AppIcons.promotion,
          label: 'ترقية المستوى',
          onTap: () => _open(context, UpgradeLevelSheet(details: details)),
        ),
        VolunteerActionRow(
          icon: AppIcons.edit,
          label: 'تعديل البيانات',
          onTap: () => _open(context, EditVolunteerDataSheet(details: details)),
        ),
        _ExportPdfRow(details: details),
        VolunteerActionRow(
          icon: AppIcons.pause,
          label: 'تعليق الحساب',
          color: ColorManager.error,
          onTap: () => _showSuspend(context),
        ),
        SizedBox(height: Space.vm),
        DeleteButton(volunteerId: details.id),
      ],
    );
  }

  void _open(BuildContext context, Widget sheet) {
    showVolunteerSheet<void>(
      context,
      BlocProvider.value(
        value: context.read<VolunteerDetailsCubit>(),
        child: sheet,
      ),
    );
  }

  Future<void> _showSuspend(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showConfirmDialog(
      context,
      title: 'تعليق الحساب',
      body: 'هل أنت متأكد من تعليق حساب ${details.name}؟',
      confirmLabel: 'تعليق',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<VolunteerDetailsCubit>().suspendAccount();
    }
  }
}

class _ExportPdfRow extends StatelessWidget {
  const _ExportPdfRow({required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VolunteerDetailsCubit, VolunteerDetailsState, bool>(
      selector: (s) => s is VolunteerDetailsExporting,
      builder: (context, exporting) => VolunteerActionRow(
        icon: AppIcons.pdf,
        label: 'تصدير بيانات المتطوع PDF',
        isLoading: exporting,
        onTap: () =>
            context.read<VolunteerDetailsCubit>().exportVolunteerPdf(details),
      ),
    );
  }
}

class _PendingApproveButton extends StatelessWidget {
  const _PendingApproveButton({required this.volunteerId, required this.name});

  final String volunteerId;
  final String name;

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'قبول الطلب',
      body: 'هل أنت متأكد من قبول $name كمتطوع؟',
      confirmLabel: 'قبول',
    );
    if (confirmed && context.mounted) {
      context.read<VolunteerDetailsCubit>().approveVolunteer(
        volunteerId,
        isPending: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VolunteerDetailsCubit, VolunteerDetailsState, bool>(
      selector: (s) => s is VolunteerDetailsApproving,
      builder: (context, approving) => PrimaryElevatedButton(
        title: 'قبول',
        icon: AppIcons.done,
        backGroundColor: ColorManager.sprout,
        isLoading: approving,
        onPress: () => _confirm(context),
      ),
    );
  }
}

class _RejectButton extends StatelessWidget {
  const _RejectButton({required this.volunteerId, required this.name});

  final String volunteerId;
  final String name;

  Future<void> _confirm(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showConfirmDialog(
      context,
      title: 'رفض الطلب',
      body: 'هل أنت متأكد من رفض طلب $name؟ لا يمكن التراجع عن هذا الإجراء.',
      confirmLabel: 'رفض',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<VolunteerDetailsCubit>().rejectVolunteer(volunteerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VolunteerDetailsCubit, VolunteerDetailsState, bool>(
      selector: (s) => s is VolunteerDetailsRejecting,
      builder: (context, rejecting) => DangerOutlineButton(
        label: 'رفض',
        icon: Icons.cancel_outlined,
        isLoading: rejecting,
        onPressed: () => _confirm(context),
      ),
    );
  }
}
