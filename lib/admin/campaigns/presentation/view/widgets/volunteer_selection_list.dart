import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class VolunteerSelectionList extends StatelessWidget {
  const VolunteerSelectionList({
    super.key,
    required this.volunteers,
    required this.selectedIds,
    required this.onToggle,
    required this.onAddPressed,
    required this.selectedVolunteers,
  });

  final List<VolunteerEntity> volunteers;
  final Set<String> selectedIds;
  final void Function(String id) onToggle;
  final VoidCallback onAddPressed;
  final List<VolunteerEntity> selectedVolunteers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryElevatedButton(title: 'إضافة متطوع', onPress: onAddPressed),
        if (selectedVolunteers.isNotEmpty) ...[
          SizedBox(height: AppHeight.s12),
          ...selectedVolunteers.map(
            (v) => _AssignedVolunteerRow(
              volunteer: v,
              onRemove: () => onToggle(v.id),
            ),
          ),
        ],
      ],
    );
  }
}

class _AssignedVolunteerRow extends StatelessWidget {
  const _AssignedVolunteerRow({
    required this.volunteer,
    required this.onRemove,
  });

  final VolunteerEntity volunteer;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        children: [
          Container(
            width: AppWidth.s34,
            height: AppHeight.s34,
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s5,
              vertical: AppHeight.s5,
            ),
            decoration: BoxDecoration(
              color: ColorManager.primary50,
              border: Border.all(width: 0.5.sp, color: ColorManager.primary500),
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Image.asset(IconAssets.vol2),
          ),
          SizedBox(width: AppWidth.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer.name,
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: ColorManager.natural600,
                  ),
                ),
                Row(
                  children: [
                    if (volunteer.region != null) ...[
                      Image.asset(
                        IconAssets.location,
                        width: AppWidth.s16,
                        height: AppHeight.s16,
                      ),
                      SizedBox(width: AppWidth.s2),
                      Text(
                        volunteer.region!,
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.natural400,
                        ),
                      ),
                      SizedBox(width: AppWidth.s8),
                    ],
                    Image.asset(
                      IconAssets.star,
                      width: AppWidth.s12,
                      height: AppWidth.s12,
                    ),
                    SizedBox(width: AppWidth.s2),
                    Text(
                      volunteer.rating.toStringAsFixed(1),
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s10,
                        color: ColorManager.natural400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove button
          GestureDetector(onTap: onRemove, child: Image.asset(IconAssets.x)),
        ],
      ),
    );
  }
}
