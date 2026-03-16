import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerManageTab extends StatelessWidget {
  const VolunteerManageTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s8,
      ),
      children: [
        _ActionRow(
          icon: Icons.assignment_outlined,
          label: 'تعيين مهمة جديدة',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon: Icons.message_outlined,
          label: 'إرسال رسالة مباشرة',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon: Icons.star_outline,
          label: 'تعديل التقييم',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon: Icons.military_tech_outlined,
          label: 'ترقية المستوى',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon: Icons.edit_outlined,
          label: 'تعديل البيانات',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon: Icons.block_outlined,
          label: 'تعليق الحساب',
          onTap: () => _showTodo(context),
        ),
        SizedBox(height: AppHeight.s16),
        _DeleteButton(volunteerId: details.id),
      ],
    );
  }

  void _showTodo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'قريباً',
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorManager.blueOne800,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s14,
        ),
        decoration: BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorManager.blueOne300, size: 20.r),
            SizedBox(width: AppWidth.s12),
            Text(
              label,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_back_ios_new,
              color: ColorManager.blueOne300,
              size: 14.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.volunteerId});

  final String volunteerId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmDelete(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s14,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.redAccent, size: 20.r),
            SizedBox(width: AppWidth.s8),
            Text(
              'حذف المتطوع',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManager.blueOne800,
          title: Text(
            'حذف المتطوع',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: Colors.white,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف هذا المتطوع؟ لا يمكن التراجع عن هذا الإجراء.',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: ColorManager.blueOne300,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'إلغاء',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: ColorManager.blueOne300,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context
                    .read<VolunteerDetailsCubit>()
                    .deleteVolunteer(volunteerId);
              },
              child: Text(
                'حذف',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
