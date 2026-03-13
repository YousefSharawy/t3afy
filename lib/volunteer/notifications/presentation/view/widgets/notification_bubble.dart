import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/style_manager.dart';
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          CircleAvatar(
            radius: 18.sp,
            backgroundColor: const Color(0xFF00ABD2).withValues(alpha: 0.15),
            child: Icon(Icons.support_agent_rounded,
                color: const Color(0xFF00ABD2), size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00ABD2),
                            Color(0xFF02389E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.sp),
                          topRight: Radius.circular(4.sp),
                          bottomLeft: Radius.circular(16.sp),
                          bottomRight: Radius.circular(16.sp),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (notification.title.isNotEmpty) ...[
                            Text(
                              notification.title,
                              style: getBoldStyle(
                                  color: Colors.white, fontSize: 14.sp),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4.h),
                          ],
                          Text(
                            notification.message,
                            style: getMediumStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.sp),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          width: 8.sp,
                          height: 8.sp,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2DD4BF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(timeAgo,
                        style: getRegularStyle(
                            color: Colors.white38, fontSize: 11.sp)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
