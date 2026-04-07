import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class TaskErrorBody extends StatelessWidget {
  const TaskErrorBody({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.r,
              color: ColorManager.error,
            ),
            SizedBox(height: AppHeight.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.error,
              ),
            ),
            SizedBox(height: AppHeight.s20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ABD2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
              ),
              child: Text(
                'إعادة المحاولة',
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
