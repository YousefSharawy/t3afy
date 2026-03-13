import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ErrorRetryBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryBody({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.error,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: AppHeight.s16),
          GestureDetector(
            onTap: onRetry,
            child: Text(
              'إعادة المحاولة',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blueOne600,
                fontSize: FontSize.s14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
