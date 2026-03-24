import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'volunteer_badge.dart';

class VolunteerCard extends StatelessWidget {
  const VolunteerCard({super.key, required this.volunteer, this.onTap});

  final AdminVolunteerEntity volunteer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = volunteer.status;
    return GestureDetector(
      onTap: onTap ?? () => context.push('/volunteerDetails/${volunteer.id}'),
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: IntrinsicHeight(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: AppWidth.s34,
                  height: AppHeight.s34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.s8)),
                    color: ColorManager.primary50,
                    border: Border.all(color: ColorManager.primary500)
                  ),
                  child: Image.asset(IconAssets.vol2),
                ),
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
                    SizedBox(height: AppHeight.s2),
                    Row(
                      children: [
                        Image.asset(
                          width: AppWidth.s16,
                          height: AppHeight.s16,
                          IconAssets.location,
                        ),
                        SizedBox(width: AppWidth.s4),
                        Flexible(
                          child: Text(
                            volunteer.region ?? 'غير محدد',
                            style: getRegularStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s10,
                              color: ColorManager.natural400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppWidth.s16),
                        Image.asset(
                          width: AppWidth.s16,
                          height: AppHeight.s16,
                          IconAssets.star,
                        ),
                        SizedBox(width: AppWidth.s4),
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
                    SizedBox(height: AppHeight.s4),
                    Row(
                      children: [
                        VolunteerBadge(
                          label: '${volunteer.totalTasks} مهمة',
                          color:  ColorManager.primary500,
                          bg: ColorManager.primary50,
                        ),
                        SizedBox(width: AppWidth.s8),
                        VolunteerBadge(
                          label: '${volunteer.totalHours} ساعة',
                           color:  ColorManager.primary500,
                          bg: ColorManager.primary50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: StatusBadge(status: status),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

}
