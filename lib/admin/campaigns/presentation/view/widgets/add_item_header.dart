import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'form_field_label.dart';

class AddItemHeader extends StatelessWidget {
  const AddItemHeader({super.key, required this.label, required this.onAdd});
  final String label;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: FormFieldLabel(label)),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(AppIcons.add, size: 18),
          label: const Text('إضافة'),
          style: TextButton.styleFrom(
            foregroundColor: ColorManager.brand,
            minimumSize: Size(AppSizes.touch, AppSizes.touch),
          ),
        ),
      ],
    );
  }
}
