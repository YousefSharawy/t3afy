import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'profile_badge.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.levelTitle,
    required this.level,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String phone;
  final String levelTitle;
  final int level;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [ColorManager.blueOne800, ColorManager.blueOne900],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.sp,
            backgroundColor: ColorManager.blueTwo200,
            backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null || avatarUrl!.isEmpty
                ? Icon(Icons.person, size: 40.sp, color: ColorManager.white)
                : null,
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            name,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            '$email | $phone',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileBadge(label: levelTitle),
              SizedBox(width: AppWidth.s8),
              ProfileBadge(label: 'المستوى $level'),
            ],
          ),
        ],
      ),
    );
  }
}
