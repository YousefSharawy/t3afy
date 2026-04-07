import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminNotificationCard extends StatelessWidget {
  final AdminNotification notification;
  final String timeAgo;
  final VoidCallback onTap;

  const AdminNotificationCard({
    super.key,
    required this.notification,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(12.sp),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: notification.isRead
              ? null
              : BorderDirectional(
                  start: BorderSide(
                    color: ColorManager.primary500,
                    width: 3.sp,
                  ),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s10,
                    vertical: AppHeight.s4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.errorLight,
                    borderRadius: BorderRadius.circular(AppRadius.s6),
                    border: Border.all(color: ColorManager.error, width: 1.sp),
                  ),
                  child: Text(
                    'تحذير عاجل',
                    style: getBoldStyle(
                      color: ColorManager.error,
                      fontSize: FontSize.s10,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s8),
            if (notification.title.isNotEmpty)
              Text(
                notification.title,
                style: getBoldStyle(
                  color: ColorManager.natural600,
                  fontSize: FontSize.s12,
                ),
              ),
            SizedBox(height: AppHeight.s4),
            Text(
              notification.body,
              style: getRegularStyle(
                color: ColorManager.natural400,
                fontSize: FontSize.s10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
