import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';

/// Destructive, low-emphasis logout that asks for confirmation first.
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key, required this.onConfirmed});

  final VoidCallback onConfirmed;

  Future<void> _confirm(BuildContext context) async {
    final ok = await showConfirmDialog(
      context,
      title: 'تسجيل الخروج',
      body: 'هل تريد تسجيل الخروج من حسابك؟',
      confirmLabel: 'تسجيل الخروج',
      isDestructive: true,
    );
    if (ok) onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _confirm(context),
        style: TextButton.styleFrom(
          foregroundColor: ColorManager.error,
          minimumSize: Size.fromHeight(AppSizes.touch),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.input),
          ),
        ),
        icon: const Icon(AppIcons.logout, color: ColorManager.error),
        label: Text(
          'تسجيل الخروج',
          style: AppText.bodyStrong(color: ColorManager.error),
        ),
      ),
    );
  }
}
