import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AddItemHeader extends StatelessWidget {
  const AddItemHeader({
    super.key,
    required this.label,
    required this.onAdd,
  });
  final String label;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: ColorManager.blueTwo900,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAdd,
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: ColorManager.cyanPrimary,
                size: 18.r,
              ),
              SizedBox(width: AppWidth.s4),
              Text(
                'إضافة',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
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
