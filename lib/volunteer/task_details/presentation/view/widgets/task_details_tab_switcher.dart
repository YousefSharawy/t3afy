import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'tab_item.dart';

class TaskDetailsTabSwitcher extends StatelessWidget {
  const TaskDetailsTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final int selectedIndex;
  final void Function(int) onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.s42,
      decoration: BoxDecoration(
        color: ColorManager.transparent,
        border: BorderDirectional(
          top: BorderSide(width: 0.5.sp, color: ColorManager.natural500),
          bottom: BorderSide(width: 0.5.sp, color: ColorManager.natural500),
        ),
      ),
      child: Row(
        children: [
          TabItem(
            label: 'التفاصيل',
            icon: IconAssets.details,
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
            isFirst: true,
          ),
          TabItem(
            label: 'المستلزمات',
            icon: IconAssets.requirements,
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
            isFirst: false,
          ),
        ],
      ),
    );
  }
}
