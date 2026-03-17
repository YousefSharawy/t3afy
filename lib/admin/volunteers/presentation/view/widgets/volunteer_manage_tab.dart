import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'approve_button.dart';
import 'delete_button.dart';
import 'volunteer_action_row.dart';

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
        if (details.role != 'volunteer')
          ApproveButton(volunteerId: details.id),
        VolunteerActionRow(
          icon: IconAssets.reports,
          label: 'تعيين مهمة جديدة',
          onTap: () => _showTodo(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.message,
          label: 'إرسال رسالة مباشرة',
          onTap: () => _showTodo(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.star,
          label: 'تعديل التقييم',
          onTap: () => _showTodo(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.promotion,
          label: 'ترقية المستوى',
          onTap: () => _showTodo(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.edit,
          label: 'تعديل البيانات',
          onTap: () => _showTodo(context),
        ),
        VolunteerActionRow(
          icon: IconAssets.settings,
          label: 'تعليق الحساب',
          onTap: () => _showTodo(context),
        ),
        SizedBox(height: AppHeight.s8),
        DeleteButton(volunteerId: details.id),
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
