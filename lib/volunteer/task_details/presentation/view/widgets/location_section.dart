import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_details_entity.dart';

import 'map_button.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key, required this.task});

  final TaskDetailsEntity task;

  bool get _hasCoords =>
      task.locationLat != null &&
      task.locationLng != null &&
      task.locationLat != 0 &&
      task.locationLng != 0;

  @override
  Widget build(BuildContext context) {
    final address = [
      task.locationName,
      task.locationAddress,
    ].where((s) => s != null && s.trim().isNotEmpty).join(' ');
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'الموقع'),
          if (address.isNotEmpty) ...[
            Text(address, style: AppText.body()),
            SizedBox(height: Space.vm),
          ],
          if (_hasCoords) ...[
            AppMapPreview(
              point: LatLng(task.locationLat!, task.locationLng!),
              height: 150,
              onTap: () => openDirections(task.locationLat!, task.locationLng!),
            ),
            SizedBox(height: Space.vm),
          ],
          MapButton(
            lat: task.locationLat,
            lng: task.locationLng,
            locationName: task.locationName,
            locationAddress: task.locationAddress,
          ),
        ],
      ),
    );
  }
}
