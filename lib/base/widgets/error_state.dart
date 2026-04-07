import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/style_manager.dart';

/// Full error state with message and retry button for BLoC error states.
/// Always provide [onRetry] (e.g. call cubit's load method again).
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 52.sp),
          SizedBox(height: 12.h),
          Text(
            message,
            style: getMediumStyle(color: Colors.white54, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00ABD2), Color(0xFF02389E)],
                ),
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Text(
                'إعادة المحاولة',
                style: getBoldStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
