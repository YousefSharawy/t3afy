import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';

/// Outlined red button for destructive actions (delete, reject).
class DangerOutlineButton extends StatelessWidget {
  const DangerOutlineButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManager.error,
        side: const BorderSide(color: ColorManager.error),
        minimumSize: Size.fromHeight(AppSizes.touch),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.input),
        ),
      ),
      icon: isLoading
          ? SizedBox(
              width: AppSizes.iconM,
              height: AppSizes.iconM,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorManager.error,
              ),
            )
          : Icon(icon, size: AppSizes.iconM),
      label: Text(
        label,
        style: getSemiBoldStyle(
          fontSize: FontSize.s15,
          color: ColorManager.error,
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.volunteerId});

  final String volunteerId;

  Future<void> _confirmDelete(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showConfirmDialog(
      context,
      title: 'حذف المتطوع',
      body: 'هل أنت متأكد من حذف هذا المتطوع؟ لا يمكن التراجع عن هذا الإجراء.',
      confirmLabel: 'حذف',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<VolunteerDetailsCubit>().deleteVolunteer(volunteerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VolunteerDetailsCubit, VolunteerDetailsState, bool>(
      selector: (s) => s is VolunteerDetailsDeleting,
      builder: (context, deleting) => DangerOutlineButton(
        label: 'حذف المتطوع',
        icon: Icons.delete_outline_rounded,
        isLoading: deleting,
        onPressed: () => _confirmDelete(context),
      ),
    );
  }
}
