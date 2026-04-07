import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class TasksTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final int todayCount;
  final int completedCount;
  final ValueChanged<int> onTabChanged;

  const TasksTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.todayCount,
    required this.completedCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppWidth.s339,
      height: AppHeight.s46,
      padding: EdgeInsets.all(6.sp),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s29),
      ),
      child: Row(
        children: [
          _buildTab('مهام اليوم ($todayCount)', 0),
          _buildTab('المنجزة ($completedCount)', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primary600 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.s25),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: getBoldStyle(
              fontSize: FontSize.s12,
              fontFamily: FontConstants.fontFamily,
              color: isSelected
                  ? ColorManager.primary50
                  : ColorManager.natural500,
            ),
          ),
        ),
      ),
    );
  }
}
