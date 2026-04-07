import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

class RoleSwitcher extends StatelessWidget {
  const RoleSwitcher(this.isVolunteer, {super.key});
  final bool isVolunteer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoleCard(
          label: 'مشرف',
          icon: Icons.admin_panel_settings_outlined,
          isSelected: !isVolunteer,
          onTap: () => context.read<AuthCubit>().toggleRole(false),
        ),
        SizedBox(width: 12.w),
        _RoleCard(
          label: 'متطوع',
          icon: Icons.volunteer_activism_outlined,
          isSelected: isVolunteer,
          onTap: () => context.read<AuthCubit>().toggleRole(true),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primary500 : ColorManager.natural100,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected
                ? ColorManager.primary500
                : ColorManager.natural200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorManager.primary500.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                icon,
                key: ValueKey(isSelected),
                size: 18.sp,
                color: isSelected
                    ? ColorManager.white
                    : ColorManager.natural400,
              ),
            ),
            SizedBox(width: 6.w),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: isSelected
                    ? ColorManager.white
                    : ColorManager.natural500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
