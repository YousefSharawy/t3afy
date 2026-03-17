import 'package:flutter/material.dart';
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
            icon: Icons.location_on_rounded,
            title: 'الموقع',
          ),
          SizedBox(height: AppHeight.s10),
          if (task.locationName != null)
            Text(
              task.locationName!,
              textAlign: TextAlign.right,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          if (task.locationAddress != null) ...[
            SizedBox(height: AppHeight.s4),
            Text(
              task.locationAddress!,
              textAlign: TextAlign.right,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
          SizedBox(height: AppHeight.s12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: MapButton(lat: task.locationLat, lng: task.locationLng),
          ),
        ],
      ),
    );
  }
}
