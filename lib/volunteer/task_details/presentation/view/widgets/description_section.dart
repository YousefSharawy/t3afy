import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'gradient_card.dart';
import 'section_header.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
           icon: IconAssets.details,
            title: 'وصف المهمة',
          ),
          SizedBox(height: AppHeight.s10),
          Text(
            description,
            textAlign: TextAlign.right,
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural400,
            ),
          ),
        ],
      ),
    );
  }
}
