import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'التفاصيل',
            icon: Icons.list_alt_outlined,
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
            isFirst: true,
          ),
          _TabItem(
            label: 'المستلزمات',
            icon: Icons.inventory_2_outlined,
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
            isFirst: false,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
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

  static const _teal = Color(0xFF00ABD2);
  static const _grey = Color(0xFF9E9E9E);
  static const _dark = Color(0xFF0C203B);

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
                color: isSelected ? _teal : Colors.transparent,
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
                color: isSelected ? _teal : _grey,
                size: 18.r,
              ),
              SizedBox(width: AppWidth.s6),
              Text(
                label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: isSelected ? _dark : _grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
