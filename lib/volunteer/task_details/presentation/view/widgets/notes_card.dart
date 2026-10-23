import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/base/widgets/app_card.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({super.key, required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: ColorManager.warningLight,
      accent: ColorManager.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'ملاحظات مهمة',
            trailing: const Icon(
              AppIcons.warning,
              color: ColorManager.warning,
              size: 22,
            ),
          ),
          Text(notes, style: AppText.body()),
        ],
      ),
    );
  }
}
