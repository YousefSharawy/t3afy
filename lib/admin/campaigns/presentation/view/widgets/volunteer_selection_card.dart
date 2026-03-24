import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';

class VolunteerSelectionCard extends StatelessWidget {
  const VolunteerSelectionCard({
    super.key,
    required this.volunteer,
    required this.isSelected,
    required this.onTap,
  });

  final VolunteerEntity volunteer;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.all(AppSize.s12),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.natural200
              : ColorManager.natural200,
          borderRadius: BorderRadius.circular(AppRadius.s10),
          border: Border.all(
            color: isSelected
                ? ColorManager.cyanPrimary
                : ColorManager.natural200,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: isSelected ? ColorManager.white : ColorManager.natural200,
              backgroundImage: volunteer.avatarUrl != null
                  ? NetworkImage(volunteer.avatarUrl!)
                  : null,
              child: volunteer.avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: ColorManager.primary500,
                      size: 16.r,
                    )
                  : null,
            ),
            SizedBox(width: AppWidth.s10),
            Expanded(
              child: Text(
                volunteer.name,
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: ColorManager.white,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: ColorManager.cyanPrimary,
                size: 18.r,
              ),
          ],
        ),
      ),
    );
  }
}
