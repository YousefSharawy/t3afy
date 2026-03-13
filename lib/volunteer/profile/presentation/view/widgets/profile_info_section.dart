import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ProfileInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.white,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[i].label,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Text(
                    items[i].value,
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.white,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ],
              ),
            ),
            if (items[i].hasDivider)
              Divider(
                color: ColorManager.white,
                thickness: 1.sp,
              ),
          ],
        ],
      ),
    );
  }
}

class ProfileInfoItem {
  final String label;
  final String value;
  final bool hasDivider;

  ProfileInfoItem({
    required this.label,
    required this.value,
    this.hasDivider = true,
  });
}