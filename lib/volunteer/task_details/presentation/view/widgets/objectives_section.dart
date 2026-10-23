import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_objective_entity.dart';

class ObjectivesSection extends StatelessWidget {
  const ObjectivesSection({super.key, required this.objectives});

  final List<TaskObjectiveEntity> objectives;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'الأهداف المطلوبة'),
          for (var i = 0; i < objectives.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == objectives.length - 1 ? 0 : Space.vm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: ColorManager.brandSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: getNumericStyle(
                        fontSize: 12,
                        color: ColorManager.brandStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: Space.m),
                  Expanded(
                    child: Text(objectives[i].title, style: AppText.body()),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
