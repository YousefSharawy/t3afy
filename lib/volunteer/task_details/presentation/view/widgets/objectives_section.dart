import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SectionHeader(
            icon: Icons.flag_rounded,
            title: 'الأهداف المطلوبة',
          ),
          SizedBox(height: AppHeight.s10),
          ...objectives.asMap().entries.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      e.value.title,
                      textAlign: TextAlign.right,
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  SizedBox(width: AppWidth.s10),
                  Container(
                    width: 26.sp,
                    height: 26.sp,
                    decoration: const BoxDecoration(
                      color: ColorManager.cyanPrimary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${e.key + 1}',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: Colors.white,
                      ),
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
