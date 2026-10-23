import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/filter_chip_item.dart';

class QuickActionChips extends StatelessWidget {
  const QuickActionChips({
    super.key,
    required this.actions,
    required this.onTap,
  });

  final List<String> actions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: Space.s,
      runSpacing: Space.vs,
      children: [
        for (final action in actions)
          FilterChipItem(
            label: action,
            selected: false,
            onTap: () => onTap(action),
          ),
      ],
    );
  }
}
