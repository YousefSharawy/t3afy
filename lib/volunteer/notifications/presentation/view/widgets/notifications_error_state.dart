import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/volunteer/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationsErrorState extends StatelessWidget {
  final NotificationsStateError state;

  const NotificationsErrorState({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.white38, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            state.message,
            style: getMediumStyle(color: Colors.white54, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
