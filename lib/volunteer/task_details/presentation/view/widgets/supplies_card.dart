import 'package:flutter/material.dart';
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          Text(
            'المواد و المستلزمات المطلوبة لهذه المهمة',
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppHeight.s20),
          if (supplies.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppHeight.s16),
              child: Text(
                'لا توجد مستلزمات لهذه المهمة',
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: Colors.white.withValues(alpha: 0.5),
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
