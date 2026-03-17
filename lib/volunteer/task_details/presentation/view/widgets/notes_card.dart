import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.amber400,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'ملاحظات مهمة',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.blueOne900,
                ),
              ),
              SizedBox(width: AppWidth.s6),
              const Icon(
                Icons.warning_amber_rounded,
                color: ColorManager.blueOne900,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: AppHeight.s8),
          Text(
            notes,
            textAlign: TextAlign.right,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: ColorManager.blueOne900,
            ),
          ),
        ],
      ),
    );
  }
}
