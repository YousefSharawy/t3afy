import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isFirst,
  });

  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;

  static const _grey = ColorManager.natural300;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? ColorManager.primary500 : Colors.transparent,
                width: 2.sp,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           Image.asset(icon,width: AppWidth.s24,height: AppHeight.s24,),
              SizedBox(width: AppWidth.s4),
              Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: isSelected ? ColorManager.primary500 : _grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
