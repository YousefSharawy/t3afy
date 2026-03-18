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
    required this.subtitle,
    this.avatarUrl,
    this.badges = const [],
    this.showCameraIcon = false,
  });

  final String name;
  final String subtitle;
  final String? avatarUrl;
  final List<ProfileBadge> badges;
  final bool showCameraIcon;

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
          _buildAvatar(),
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
            subtitle,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s14,
            ),
          ),
          if (badges.isNotEmpty) ...[
            SizedBox(height: AppHeight.s8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < badges.length; i++) ...[
                  badges[i],
                  if (i < badges.length - 1) SizedBox(width: AppWidth.s8),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final avatar = CircleAvatar(
      radius: 40.sp,
      backgroundColor: ColorManager.blueTwo200,
      backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? Icon(Icons.person, size: 40.sp, color: ColorManager.white)
          : null,
    );

    if (!showCameraIcon) return avatar;

    return Stack(
      children: [
        avatar,
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: const BoxDecoration(
              color: Color(0xFF00ABD2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 14.sp,
              color: ColorManager.white,
            ),
          ),
        ),
      ],
    );
  }
}
