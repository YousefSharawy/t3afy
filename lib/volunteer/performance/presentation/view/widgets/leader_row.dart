import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class LeaderRow extends StatelessWidget {
  const LeaderRow({
    super.key,
    required this.name,
    required this.hours,
    required this.pts,
    required this.isMe,
    required this.medal,
  });

  final String name;
  final int hours;
  final int pts;
  final bool isMe;
  final String medal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s6,
        horizontal: AppWidth.s18,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: isMe
            ? Border.all(color: ColorManager.primary500, width: 1.sp)
            : null,
      ),
      child: Row(
        children: [
          Image.asset(
            IconAssets.medal,
            width: AppWidth.s24,
            height: AppHeight.s24,
          ),
          SizedBox(width: AppWidth.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural600,
                  fontSize: FontSize.s14,
                ),
              ),
              Text(
                '$hours ساعة',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural300,
                  fontSize: FontSize.s10,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'pts $pts',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.warning,
              fontSize: FontSize.s15,
            ),
          ),
        ],
      ),
    );
  }
}
