import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_supply_entity.dart';

import 'supply_row.dart';

class SuppliesCard extends StatelessWidget {
  const SuppliesCard({super.key, required this.supplies});

  final List<TaskSupplyEntity> supplies;

  @override
  Widget build(BuildContext context) {
    if (supplies.isEmpty) {
      return const AppCard(
        child: AppEmptyState(
          compact: true,
          icon: AppIcons.requirements,
          title: 'لا توجد مستلزمات لهذه المهمة',
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'المواد والمستلزمات المطلوبة'),
        for (var i = 0; i < supplies.length; i++) ...[
          if (i > 0) SizedBox(height: Space.vs),
          SupplyRow(key: ValueKey(supplies[i].id), supply: supplies[i]),
        ],
      ],
    );
  }
}
