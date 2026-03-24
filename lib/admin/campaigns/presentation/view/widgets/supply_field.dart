import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class SupplyField extends StatelessWidget {
  const SupplyField({
    super.key,
    required this.nameController,
    required this.quantityController,
    required this.onRemove,
    required this.index,
  });

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final VoidCallback onRemove;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: PrimaryTextFF(
              textAlign: .right,
              controller: nameController,
              hint: 'اسم المستلزم',
            ),
          ),
          SizedBox(width: AppWidth.s8),
          Expanded(
            flex: 1,
            child: PrimaryTextFF(
              textAlign: .right,
              controller: quantityController,
              hint: 'الكمية',
              keyboardType: TextInputType.number,
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
