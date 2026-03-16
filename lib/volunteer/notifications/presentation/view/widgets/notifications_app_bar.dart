import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';

class NotificationsAppBar {
  NotificationsAppBar._();

  static AppBar build(BuildContext context, {VoidCallback? onMarkAllRead}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.black, size: 20.sp),
      ),
      centerTitle: true,
      title: Text(
        'التنبيهات والاشعارات',
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s16,
          color: ColorManager.blueOne900,
        ),
      ),
      actions: [
        if (onMarkAllRead != null)
          TextButton(
            onPressed: onMarkAllRead,
            child: Text(
              'قراءة الكل',
              style: getMediumStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
      ],
    );
  }
}
