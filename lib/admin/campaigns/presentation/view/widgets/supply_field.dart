import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: nameController,
              textDirection: TextDirection.rtl,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'اسم المستلزم',
                hintStyle: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                filled: true,
                fillColor: ColorManager.blueOne800,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s12,
                  vertical: AppHeight.s10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  borderSide: BorderSide(color: ColorManager.blueOne700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  borderSide: BorderSide(color: ColorManager.blueOne700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  borderSide: const BorderSide(color: Color(0xFF00ABD2)),
                ),
              ),
            ),
          ),
          SizedBox(width: AppWidth.s8),
          Expanded(
            flex: 1,
            child: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.rtl,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'الكمية',
                hintStyle: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s11,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                filled: true,
                fillColor: ColorManager.blueOne800,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s8,
                  vertical: AppHeight.s10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  borderSide: BorderSide(color: ColorManager.blueOne700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  borderSide: BorderSide(color: ColorManager.blueOne700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s10),
                  borderSide: const BorderSide(color: Color(0xFF00ABD2)),
                ),
              ),
            ),
          ),
          SizedBox(width: AppWidth.s8),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(AppSize.s8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.redAccent,
                size: AppSize.s18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
