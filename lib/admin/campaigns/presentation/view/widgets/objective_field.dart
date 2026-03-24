import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
      padding: EdgeInsets.only(bottom: AppHeight.s8),
      child: Row(
        children: [
          Expanded(
            child: PrimaryTextFF(
              textAlign: .right,
              controller: controller,
              hint: 'هدف ${index + 1}',
            ),
          ),
          SizedBox(width: AppWidth.s8),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(AppSize.s8),
              decoration: BoxDecoration(
                color: ColorManager.errorLight,
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Icon(
                Icons.remove_circle_outline,
                color: ColorManager.error,
                size: AppSize.s18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
