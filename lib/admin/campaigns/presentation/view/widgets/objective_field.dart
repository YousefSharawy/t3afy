import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class ObjectiveField extends StatelessWidget {
  const ObjectiveField({
    super.key,
    required this.controller,
    required this.onRemove,
    required this.index,
  });

  final TextEditingController controller;
  final VoidCallback onRemove;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Space.vs),
      child: Row(
        children: [
          Expanded(
            child: PrimaryTextFF(controller: controller, hint: 'هدف ${index + 1}'),
          ),
          RemoveFieldButton(onPressed: onRemove),
        ],
      ),
    );
  }
}

class RemoveFieldButton extends StatelessWidget {
  const RemoveFieldButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'حذف',
      onPressed: onPressed,
      icon: const Icon(
        Icons.remove_circle_outline_rounded,
        color: ColorManager.error,
      ),
    );
  }
}
