import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key, required this.items});

  final List<ProfileInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[i].label,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural400,
                      fontSize: FontSize.s12,
                    ),
                  ),
                  Text(
                    items[i].value,
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural400,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
            if (items[i].hasDivider)
              Center(
                child: SizedBox(
                  width: AppWidth.s108,
                  child: Divider(
                    color: ColorManager.natural200,
                    thickness: 1.sp,
                  ),
                ),
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
