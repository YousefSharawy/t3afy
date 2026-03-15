import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({
    super.key,
    required this.adminName,
    this.avatarUrl,
    this.onNotificationTap,
  });

  final String adminName;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s18,
      ),
      child: Row(
        children: [
          Column(

            crossAxisAlignment: .start,
            children: [
              SizedBox(height: AppHeight.s71,),
              CircleAvatar(
                radius: 24.r,
                backgroundColor: ColorManager.blueOne600,
                backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null || avatarUrl!.isEmpty
                    ? Icon(Icons.person, color: Colors.white, size: 28.r)
                    : null,
              ),
            ],
          ),
          SizedBox(width: AppWidth.s12),
            Text(
                adminName,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppHeight.s2),
              Text(
                'لوحة تحكم',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.blueOne100,
                ),
              ),
        ],
      ),
    );
  }
}
