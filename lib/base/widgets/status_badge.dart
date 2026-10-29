import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

typedef StatusStyle = ({
  String label,
  Color textColor,
  Color fillColor,
  Color accent,
});

/// The single status → label/color map for the whole app (both roles).
/// Cards use [StatusBadge.styleOf] for their accent so colors always agree.
class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;
  const StatusBadge({super.key, required this.status, this.compact = false});

  static StatusStyle styleOf(String status) {
    return switch (status) {
      'active' || 'ongoing' || 'in_progress' || 'checked_in' => (
        label: 'جارية',
        textColor: ColorManager.brandStrong,
        fillColor: ColorManager.brandSoft,
        accent: ColorManager.brand,
      ),
      'upcoming' || 'scheduled' => (
        label: 'قادمة',
        textColor: ColorManager.warning,
        fillColor: ColorManager.warningLight,
        accent: ColorManager.warning,
      ),
      'cancelled' || 'paused' => (
        label: 'موقوفة',
        textColor: ColorManager.natural700,
        fillColor: ColorManager.natural100,
        accent: ColorManager.natural400,
      ),
      'done' || 'completed' => (
        label: 'مكتملة',
        textColor: ColorManager.sproutText,
        fillColor: ColorManager.sproutSoft,
        accent: ColorManager.sprout,
      ),
      'assigned' || 'نشط' => (
        label: 'نشط',
        textColor: ColorManager.sproutText,
        fillColor: ColorManager.sproutSoft,
        accent: ColorManager.sprout,
      ),
      'offline' || 'inactive' || 'غير نشط' => (
        label: 'غير نشط',
        textColor: ColorManager.natural600,
        fillColor: ColorManager.natural100,
        accent: ColorManager.natural300,
      ),
      'pending' || 'pending_review' || 'user' || 'قيد المراجعة' => (
        label: 'قيد المراجعة',
        textColor: ColorManager.warning,
        fillColor: ColorManager.warningLight,
        accent: ColorManager.warning,
      ),
      'missed' => (
        label: 'فائتة',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
        accent: ColorManager.error,
      ),
      'suspended' => (
        label: 'معلق',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
        accent: ColorManager.error,
      ),
      'approved' => (
        label: 'موافق عليه',
        textColor: ColorManager.sproutText,
        fillColor: ColorManager.sproutSoft,
        accent: ColorManager.sprout,
      ),
      'rejected' => (
        label: 'مرفوض',
        textColor: ColorManager.error,
        fillColor: ColorManager.errorLight,
        accent: ColorManager.error,
      ),
      _ => (
        label: status,
        textColor: ColorManager.natural600,
        fillColor: ColorManager.natural100,
        accent: ColorManager.natural300,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = styleOf(status);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: compact ? Space.s : Space.m * 0.85,
        vertical: compact ? Space.vxs * 0.5 : Space.vxs,
      ),
      decoration: BoxDecoration(
        color: style.fillColor,
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: style.accent,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: Space.xs + 1),
          Flexible(
            child: Text(
              style.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                color: style.textColor,
                fontSize: compact ? FontSize.s11 : FontSize.s12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
