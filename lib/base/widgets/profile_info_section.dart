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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[i].label,
                    style: getMediumStyle(
                      color: ColorManager.inkMuted,
                      fontSize: FontSize.s13,
                    ),
                  ),
                  SizedBox(width: AppWidth.s12),
                  Flexible(
                    child: Text(
                      items[i].value,
                      textAlign: TextAlign.end,
                      style: getSemiBoldStyle(
                        color: ColorManager.ink,
                        fontSize: FontSize.s13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (items[i].hasDivider)
              Divider(height: 1, thickness: 1, color: ColorManager.line),
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
