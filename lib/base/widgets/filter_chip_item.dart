import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class FilterChipItem extends StatelessWidget {
  const FilterChipItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor = ColorManager.primary500,
    this.unselectedColor = ColorManager.blueOne900,
    this.borderRadius,
    this.horizontalPadding,
    this.border,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final double? borderRadius;
  final double? horizontalPadding;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? AppWidth.s10,
        ),
        decoration: BoxDecoration(
          color: selectedColor,
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.s8),
        ),
        child: Center(
          child: Text(
            label,
            style: selected
                ? getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: ColorManager.white,
                  )
                : getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: ColorManager.primary50,
                  ),
          ),
        ),
      ),
    );
  }
}
