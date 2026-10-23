import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/base/widgets/app_card.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'وصف المهمة'),
          Text(description, style: AppText.body()),
        ],
      ),
    );
  }
}
