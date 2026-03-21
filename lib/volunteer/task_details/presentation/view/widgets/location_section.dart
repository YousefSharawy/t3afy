import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_details_entity.dart';
import 'gradient_card.dart';
import 'map_button.dart';
import 'section_header.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: IconAssets.location,
            title: 'الموقع',
          ),
          SizedBox(height: AppHeight.s8),
          if (task.locationName != null)
            Text(
              "${task.locationName!} ${task.locationAddress??""}",
              textAlign: TextAlign.right,
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural400,
              ),
            ),
          SizedBox(height: AppHeight.s8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: MapButton(lat: task.locationLat, lng: task.locationLng),
          ),
        ],
      ),
    );
  }
}
