import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_supply_entity.dart';
import 'supply_row.dart';

class SuppliesCard extends StatelessWidget {
  const SuppliesCard({super.key, required this.supplies});

  final List<TaskSupplyEntity> supplies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s20,
        vertical: AppHeight.s16,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'المواد و المستلزمات المطلوبة لهذه المهمة',
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural600,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          if (supplies.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppHeight.s16),
              child: Text(
                'لا توجد مستلزمات لهذه المهمة',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: ColorManager.natural500,
                ),
              ),
            )
          else
            ...supplies.map((s) => SupplyRow(supply: s)),
        ],
      ),
    );
  }
}
