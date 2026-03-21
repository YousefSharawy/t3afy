import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class BotInfoRow extends StatelessWidget {
  const BotInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            ImageAssets.botAvatar,
            width: AppWidth.s40,
            height: AppHeight.s40,
          ),
          SizedBox(width: 8.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'مساعد الصندوق',
                style: getBoldStyle(
                  fontSize: FontSize.s16,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural900,
                ),
              ),
              Text(
                ' متاح الان',
                style: getMediumStyle(
                  fontSize: FontSize.s13,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
