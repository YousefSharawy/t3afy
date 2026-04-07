import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_objective_entity.dart';
import 'gradient_card.dart';
import 'section_header.dart';

class ObjectivesSection extends StatelessWidget {
  const ObjectivesSection({super.key, required this.objectives});

  final List<TaskObjectiveEntity> objectives;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        children: [
          SectionHeader(icon: IconAssets.target, title: 'الأهداف المطلوبة'),
          SizedBox(height: AppHeight.s16),
          ...objectives.asMap().entries.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: AppWidth.s15,
                    height: AppHeight.s15,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topLeft,
                        end: .bottomRight,
                        colors: [Color(0xff36DFF1), Color(0xff2764E7)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: getExtraBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppWidth.s5),
                  Text(
                    e.value.title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s12,
                      color: ColorManager.natural400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
