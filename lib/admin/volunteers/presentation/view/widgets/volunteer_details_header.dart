import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'volunteer_detail_stat_box.dart';

class VolunteerDetailsHeader extends StatelessWidget {
  const VolunteerDetailsHeader({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: AppWidth.s48,
                    height: AppHeight.s48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                      color: ColorManager.primary50,
                      border: Border.all(
                        color: ColorManager.primary500,
                        width: 0.5.sp,
                      ),
                    ),
                    child: Image.asset(IconAssets.volHome),
                  ),
                ],
              ),
              SizedBox(width: AppWidth.s8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    details.name,
                    style: getExtraBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: ColorManager.natural600,
                    ),
                  ),
                  SizedBox(height: AppHeight.s7),
                  Row(
                    children: [
                      StatusBadge(status: details.status),
                      SizedBox(width: AppWidth.s13),
                      Text(
                        'المستوى ${details.level}',
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s12,
                          color: ColorManager.natural400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Image.asset(
                          i < details.rating.round()
                              ? IconAssets.star
                              : IconAssets.unstar,
                        );
                      }),
                      SizedBox(width: AppWidth.s7),
                      Text(
                        details.rating.toStringAsFixed(1),
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s12,
                          color: ColorManager.natural400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.s8),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: VolunteerDetailStatBox(
                  value: '${details.totalTasks}',
                  label: 'مهمة',
                  icon: IconAssets.done,
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: VolunteerDetailStatBox(
                  value: '${details.totalHours}',
                  label: 'ساعة',
                  icon: IconAssets.alarm,
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: VolunteerDetailStatBox(
                  value: '${details.level}',
                  label: 'مستوى',
                  icon: IconAssets.trophy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
