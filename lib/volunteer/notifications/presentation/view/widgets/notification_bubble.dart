import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';

class NotificationBubble extends StatelessWidget {
  final AdminNote notification;
  final String timeAgo;
  final VoidCallback onTap;

  const NotificationBubble({
    super.key,
    required this.notification,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(12.sp),
        decoration: BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: AppWidth.s40,
                  height: AppHeight.s40,
                  decoration: BoxDecoration(
                    color: ColorManager.blueThree900,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                    border: Border.all(
                      width: AppWidth.s1,
                      color: ColorManager.blueTwo400,
                    ),
                  ),
                  child: Image.asset(
                    IconAssets.warning,
                    width: AppWidth.s24,
                    height: AppHeight.s24,
                  ),
                ),
              ],
            ),
            SizedBox(width: AppWidth.s16),
            Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s10,
                    vertical: AppHeight.s4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.blueThree900,
                    borderRadius: BorderRadius.circular(AppRadius.s6),
                  ),
                  child: Text(
                    'تحذير عاجل',
                    style: getExtraBoldStyle(
                      color: ColorManager.blueThree300,
                      fontSize: FontSize.s10,
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s10),
                if (notification.title.isNotEmpty) ...[
                  Text(
                    notification.title,
                    style: getBoldStyle(color: Colors.white, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
                  SizedBox(height: AppHeight.s4),
                  Text(
              notification.message,
              style: getMediumStyle(color: Colors.white60, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
              ],
            ),

            // Title

            // // Body
          
          
            // Bottom row: unread dot + timeAgo
            // Row(
            //   textDirection: TextDirection.rtl,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       timeAgo,
            //       style: getRegularStyle(
            //         color: Colors.white38,
            //         fontSize: 11.sp,
            //       ),
            //     ),
            //     if (!isRead)
            //       Container(
            //         width: 8.sp,
            //         height: 8.sp,
            //         decoration: const BoxDecoration(
            //           color: Color(0xFF2DD4BF),
            //           shape: BoxShape.circle,
            //         ),
            //       ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
