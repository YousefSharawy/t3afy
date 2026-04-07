import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
  });

  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String Function(String)? itemLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s12,
            color: ColorManager.natural400,
          ),
        ),
        SizedBox(height: AppHeight.s6),
        PopupMenuButton<String>(
          onSelected: onChanged,
          offset: Offset(0.sp, 2.sp),
          position: PopupMenuPosition.under,
          color: ColorManager.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s8),
          ),
          itemBuilder: (context) => items
              .map(
                (e) => PopupMenuItem<String>(
                  value: e,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      itemLabel != null ? itemLabel!(e) : e,
                      style: TextStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontWeightManager.bold,
                        color: ColorManager.natural900,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          child: Container(
            constraints: BoxConstraints(minHeight: AppHeight.s42),
            decoration: BoxDecoration(
              border: Border.all(width: 1.sp, color: ColorManager.natural200),
              color: ColorManager.natural100,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Row(
              children: [
                SizedBox(width: AppWidth.s15),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.sp,
                  color: ColorManager.blueOne900,
                ),
                SizedBox(width: AppWidth.s12),
                Text(
                  itemLabel != null ? itemLabel!(value) : value,
                  style: TextStyle(
                    fontSize: FontSize.s14,
                    fontWeight: FontWeightManager.bold,
                    color: ColorManager.natural900,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
