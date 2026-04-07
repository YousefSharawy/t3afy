import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
      padding: EdgeInsets.all(AppSize.s12),
      decoration: BoxDecoration(
        color: ColorManager.warning,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(IconAssets.warning),
              SizedBox(width: AppWidth.s8),
              Text(
                'ملاحظات مهمة',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: ColorManager.warningLight,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s9),
          Text(
            notes,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}
