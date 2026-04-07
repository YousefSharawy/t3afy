import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'profile_badge.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.badges = const [],
  });

  final String name;
  final String subtitle;
  final String? avatarUrl;
  final List<ProfileBadge> badges;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          PrimaryCircularAvatar(
            size: 80.sp,
            color: ColorManager.blueTwo200,
            image: avatarUrl != null && avatarUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(avatarUrl!),
                    fit: BoxFit.cover,
                  )
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
              color: ColorManager.natural600,
              fontSize: FontSize.s14,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            subtitle,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural500,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }
}
