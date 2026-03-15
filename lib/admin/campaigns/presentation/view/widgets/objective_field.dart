import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
            child: TextField(
              controller: controller,
              textDirection: TextDirection.rtl,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'هدف ${index + 1}',
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
