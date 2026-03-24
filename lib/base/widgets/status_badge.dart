import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  static ({String label, Color textColor, Color fillColor}) _getStatusStyle(
    String status,
  ) {
    return switch (status) {
      'active' || 'ongoing' => (
        label: 'جارية',
        textColor: ColorManager.info,
        fillColor: ColorManager.infoLight,
      ),
      'upcoming' => (
        label: 'قادمة',
        textColor: ColorManager.warning,
        fillColor: ColorManager.warningLight,
      ),
      'cancelled' || 'paused' => (
        label: 'موقوفة',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
      ),
      'done' || 'completed' => (
        label: 'مكتملة',
        textColor: ColorManager.success,
        fillColor: ColorManager.successLight,
      ),
      'assigned' || 'نشط' => (
        label: 'نشط',
        textColor: ColorManager.success,
        fillColor: ColorManager.successLight,
      ),
      'offline' || 'inactive' || 'غير نشط' => (
        label: 'غير نشط',
        textColor: ColorManager.natural500,
        fillColor: ColorManager.natural200,
      ),
      'pending' || 'user' || 'قيد المراجعة' => (
        label: 'قيد المراجعة',
        textColor: ColorManager.warning,
        fillColor: ColorManager.warningLight,
      ),
      'missed' => (
        label: 'فائت',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
      ),
      'suspended' => (
        label: 'معلق',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
      ),
      'approved' => (
        label: 'موافق عليه',
        textColor: ColorManager.success,
        fillColor: ColorManager.successLight,
      ),
      'rejected' => (
        label: 'مرفوض',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
      ),
      _ => (
        label: status,
      textColor: ColorManager.natural500,
        fillColor: ColorManager.natural200,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = _getStatusStyle(status);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppWidth.s10,
        vertical: AppHeight.s2,
      ),
      decoration: BoxDecoration(
        color: style.fillColor,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: style.textColor, width: 0.5.sp),
      ),
      child: Text(
        style.label,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          color: style.textColor,
          fontSize: FontSize.s10,
        ),
      ),
    );
  }
}
