import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AddItemHeader extends StatelessWidget {
  const AddItemHeader({super.key, required this.label, required this.onAdd});
  final String label;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: ColorManager.natural900,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAdd,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                IconAssets.add2,
                width: AppWidth.s12,
                height: AppWidth.s12,
              ),
              SizedBox(width: AppWidth.s4),
              Text(
                'إضافة',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.cyanPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
