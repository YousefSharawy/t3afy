import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class TodayTaskCard extends StatelessWidget {
  const TodayTaskCard({super.key, required this.task, this.onTap});

  final TaskEntity task;
  final VoidCallback? onTap;

  String get _statusLabel {
    switch (task.status) {
      case 'ongoing':
      case 'active':
        return 'جارية';
      case 'upcoming':
        return 'قادمة';
      case 'completed':
      case 'done':
        return 'مكتملة';
      default:
        return task.status;
    }
  }

  Color get _statusTextColor {
    switch (task.status) {
      case 'ongoing':
      case 'active':
        return ColorManager.info;
      case 'upcoming':
        return ColorManager.warning;
      case 'completed':
      case 'done':
        return ColorManager.success;
      default:
        return Colors.grey;
    }
  }

  Color get _statusFillColor {
    switch (task.status) {
      case 'ongoing':
      case 'active':
        return ColorManager.infoLight;
      case 'upcoming':
        return ColorManager.warningLight;
      case 'completed':
      case 'done':
        return ColorManager.successLight;
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppWidth.s339,
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s8,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: BorderDirectional(
            start: BorderSide(color: _statusTextColor, width: AppWidth.s3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    task.title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural500,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        IconAssets.hours,
                        width: AppWidth.s14,
                        height: AppHeight.s14,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        '${task.timeStart} ص',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.natural300,
                          fontSize: FontSize.s10,
                        ),
                      ),
                      SizedBox(width: AppWidth.s4),
                      Image.asset(
                        IconAssets.location,
                        width: AppWidth.s14,
                        height: AppHeight.s14,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        task.locationName,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.natural300,
                          fontSize: FontSize.s10,
                        ),
                      ),
                    ],
                  ),
                  // Title
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s10,
                    vertical: AppHeight.s2,
                  ),
                  decoration: BoxDecoration(
                    color: _statusFillColor,
                    borderRadius: BorderRadius.circular(AppRadius.s6),
                    border: Border.all(color: _statusTextColor, width: 0.5.sp),
                  ),
                  child: Text(
                    _statusLabel,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: _statusTextColor,
                      fontSize: FontSize.s10,
                    ),
                  ),
                ),
                Text(
                  '${task.points} +نقطة',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.warning,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
            //

            // ),
          ],
        ),
      ),
    );
  }
}
