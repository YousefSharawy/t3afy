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
      return const Color(0xFF00FFCF);
    case 'upcoming':
      return const Color(0xFFFFA600);
    case 'completed':
    case 'done':
      return ColorManager.blueThree500;
    default:
      return Colors.grey;
  }
}

Color get _statusFillColor {
  switch (task.status) {
    case 'ongoing':
    case 'active':
      return const Color(0xFF147489);
    case 'upcoming':
      return const Color(0xffD08E00).withOpacity(0.45);
    case 'completed':
    case 'done':
      return const Color(0xFF0D2D5A);
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
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [ColorManager.blueOne800, ColorManager.blueOne900],
          ),
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(
            width: 0.5.sp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    task.title,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s10,
                    vertical: AppHeight.s2,
                  ),
                  decoration: BoxDecoration(
                    color: _statusFillColor,
                    borderRadius: BorderRadius.circular(AppRadius.s6),
                    border: Border.all(color: _statusTextColor, width: 1.sp),
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
                // Title
              ],
            ),
            SizedBox(height: AppWidth.s4),
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
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blueTwo200,
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
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blueTwo200,
                    fontSize: FontSize.s10,
                  ),
                ),
                const Spacer(),
                Text(
                  '+${task.points}',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: Color(0xffFFCC00),
                    fontSize: FontSize.s10,
                  ),
                ),
                Text(
                  'نقطة',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: Color(0xffFFCC00),
                    fontSize: FontSize.s10,
                  ),
                ),

                // Location
              ],
            ),
          ],
        ),
      ),
    );
  }
}
