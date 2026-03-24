import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/assign_task_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/edit_rating_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/edit_volunteer_data_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/send_message_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/upgrade_level_sheet.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'delete_button.dart';
import 'volunteer_action_row.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isPending = details.role == 'user';
    return BlocListener<VolunteerDetailsCubit, VolunteerDetailsState>(
      listener: (context, state) {
        if (state is VolunteerDetailsSuspended) {
          context.pop(true);
          Toast.success.show(context, title: 'تم تعليق الحساب بنجاح');
        } else if (state is VolunteerDetailsActionSuccess) {
          if (state.message == 'تم قبول المتطوع' ||
              state.message == 'تم رفض الطلب') {
            Toast.success.show(context, title: state.message);
            context.pop(true);
          }
        }
      },
      child: isPending
          ? _buildPendingActions(context)
          : _buildVolunteerActions(context),
    );
  }

  Widget _buildPendingActions(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: AppHeight.s16),
        _PendingApproveButton(volunteerId: details.id),
        SizedBox(height: AppHeight.s8),
        _RejectButton(volunteerId: details.id, name: details.name),
        SizedBox(height: AppHeight.s50),
      ],
    );
  }

  Widget _buildVolunteerActions(BuildContext context) {
    return ListView(
      children: [
        VolunteerActionRow(
          icon: IconAssets.reports,
          label: 'تعيين مهمة جديدة',
          onTap: () => _showAssignTask(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.message,
          label: 'إرسال رسالة مباشرة',
          onTap: () => _showSendMessage(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.star,
          label: 'تعديل التقييم',
          onTap: () => _showEditRating(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.promotion,
          label: 'ترقية المستوى',
          onTap: () => _showUpgradeLevel(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.edit,
          label: 'تعديل البيانات',
          onTap: () => _showEditData(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.settings,
          label: 'تعليق الحساب',
          onTap: () => _showSuspend(context),
        ),
        SizedBox(height: AppHeight.s8),
        DeleteButton(volunteerId: details.id),
        SizedBox(height: AppHeight.s50),
      ],
    );
  }

  void _showAssignTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VolunteerDetailsCubit>(),
        child: const AssignTaskSheet(),
      ),
    );
  }

  void _showSendMessage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VolunteerDetailsCubit>(),
        child: const SendMessageSheet(),
      ),
    );
  }

  void _showEditRating(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VolunteerDetailsCubit>(),
        child: EditRatingSheet(currentRating: details.rating),
      ),
    );
  }

  void _showUpgradeLevel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VolunteerDetailsCubit>(),
        child: UpgradeLevelSheet(details: details),
      ),
    );
  }

  void _showEditData(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VolunteerDetailsCubit>(),
        child: EditVolunteerDataSheet(details: details),
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

class _PendingApproveButton extends StatelessWidget {
  const _PendingApproveButton({required this.volunteerId});

  final String volunteerId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirm(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorManager.successLight, Color(0xFF166534)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                color: ColorManager.successLight, size: 20),
            SizedBox(width: AppWidth.s8),
            Text(
              'قبول',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.successLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
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
            'قبول الطلب',
            style: getSemiBoldStyle(
              color: ColorManager.natural900,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'هل أنت متأكد من قبول هذا المتطوع؟',
            style: getRegularStyle(
              color: ColorManager.natural900.withValues(alpha: 0.7),
              fontSize: FontSize.s14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('إلغاء',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: ColorManager.natural900.withValues(alpha: 0.6),
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary500,
                foregroundColor: ColorManager.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s30),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(ctx).pop();
                context
                    .read<VolunteerDetailsCubit>()
                    .approveVolunteer(volunteerId, isPending: true);
              },
              child: Text('قبول',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: ColorManager.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _RejectButton extends StatelessWidget {
  const _RejectButton({required this.volunteerId, required this.name});

  final String volunteerId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirm(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s14,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s8),
          border: Border.all(color: ColorManager.error),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel_outlined, color: ColorManager.error, size: 20),
            SizedBox(width: AppWidth.s8),
            Text(
              'رفض',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}
