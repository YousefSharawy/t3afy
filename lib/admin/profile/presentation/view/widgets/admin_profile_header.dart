import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminProfileHeader extends StatelessWidget {
  const AdminProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s20,
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
          Stack(
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
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00ABD2),
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
          ),
          SizedBox(height: AppHeight.s8),
          Text(
            name,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            email,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s13,
            ),
          ),
          SizedBox(height: AppHeight.s10),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s12,
              vertical: AppHeight.s4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF00ABD2),
              borderRadius: BorderRadius.circular(AppRadius.s25),
            ),
            child: Text(
              'مدير النظام',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.white,
                fontSize: FontSize.s11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
