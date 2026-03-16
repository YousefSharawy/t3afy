import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
          icon:IconAssets.reports,
          label: 'تعيين مهمة جديدة',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon:IconAssets.message,
          label: 'إرسال رسالة مباشرة',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon:IconAssets.star,
          label: 'تعديل التقييم',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon:IconAssets.promotion,
          label: 'ترقية المستوى',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon:IconAssets.edit,
          label: 'تعديل البيانات',
          onTap: () => _showTodo(context),
        ),
        _ActionRow(
          icon:IconAssets.settings,
          label: 'تعليق الحساب',
          onTap: () => _showTodo(context),
        ),
        SizedBox(height: AppHeight.s8),
        _DeleteButton(volunteerId: details.id),
                SizedBox(height: AppHeight.s50),
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

  final String icon;
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
         gradient: LinearGradient(
          
          begin: .centerLeft,
          end: .centerRight,
          colors: [
          ColorManager.blueOne900,
          ColorManager.blueOne800,
         ]),
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Row(
          children: [
            Container(
              width: AppWidth.s32,
              height: AppHeight.s32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.s8),
                color: Color(0xff1F2E4F)
              ),
              
              child: Image.asset(icon)),
            SizedBox(width: AppWidth.s8),
            Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.blueOne50,
              ),
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
          vertical: AppHeight.s8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: AppWidth.s2),
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حذف المتطوع',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
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
                context.read<VolunteerDetailsCubit>().deleteVolunteer(
                  volunteerId,
                );
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
