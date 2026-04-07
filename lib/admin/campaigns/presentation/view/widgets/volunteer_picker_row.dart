import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerPickerRow extends StatelessWidget {
  const VolunteerPickerRow({
    super.key,
    required this.volunteer,
    required this.isSelected,
  });

  final VolunteerEntity volunteer;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: AppHeight.s10),
      padding: EdgeInsets.all(AppSize.s12),
      decoration: BoxDecoration(
        color: isSelected
            ? ColorManager.primary500.withValues(alpha: 0.08)
            : ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: isSelected
              ? ColorManager.primary500.withValues(alpha: 0.4)
              : ColorManager.natural200,
          width: isSelected ? 1 : 0.5,
        ),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: isSelected
                ? Icon(
                    Icons.check_circle,
                    key: const ValueKey('checked'),
                    color: ColorManager.primary500,
                    size: 22.r,
                  )
                : Container(
                    key: const ValueKey('unchecked'),
                    width: AppWidth.s32,
                    height: AppHeight.s32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5.sp,
                        color: ColorManager.primary500,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                      color: ColorManager.primary50,
                    ),
                    child: Image.asset(IconAssets.vol2),
                  ),
          ),
          SizedBox(width: AppWidth.s12),
          Expanded(
            child: Text(
              volunteer.name,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: ColorManager.natural900,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 13.r,
                color: const Color(0xFFFBBF24),
              ),
              SizedBox(width: AppWidth.s2),
              Text(
                volunteer.rating.toStringAsFixed(1),
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s11,
                  color: ColorManager.natural400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
