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
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;

  static const _grey = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppHeight.s14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? ColorManager.cyanPrimary : Colors.transparent,
                width: 3,
              ),
            ),
            borderRadius: isSelected
                ? null
                : BorderRadius.only(
                    topRight:
                        isFirst ? Radius.circular(AppRadius.s12) : Radius.zero,
                    bottomRight:
                        isFirst ? Radius.circular(AppRadius.s12) : Radius.zero,
                    topLeft:
                        isFirst ? Radius.zero : Radius.circular(AppRadius.s12),
                    bottomLeft:
                        isFirst ? Radius.zero : Radius.circular(AppRadius.s12),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? ColorManager.cyanPrimary : _grey,
                size: 18.r,
              ),
              SizedBox(width: AppWidth.s6),
              Text(
                label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: isSelected ? ColorManager.blueOne900 : _grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
