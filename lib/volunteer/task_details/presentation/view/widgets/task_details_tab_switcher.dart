import 'package:flutter/material.dart';
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
          TabItem(
            label: 'التفاصيل',
            icon: Icons.list_alt_outlined,
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
            isFirst: true,
          ),
          TabItem(
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
