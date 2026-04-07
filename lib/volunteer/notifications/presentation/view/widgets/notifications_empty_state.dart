import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/style_manager.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: Colors.white38,
            size: 64.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد إشعارات',
            style: getMediumStyle(color: Colors.white54, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
