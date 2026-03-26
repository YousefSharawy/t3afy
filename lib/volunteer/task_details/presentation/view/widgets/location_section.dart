import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
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

  bool get _hasCoords =>
      task.locationLat != null &&
      task.locationLng != null &&
      task.locationLat != 0 &&
      task.locationLng != 0;

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
              '${task.locationName!} ${task.locationAddress ?? ''}',
              textAlign: TextAlign.right,
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural400,
              ),
            ),
          if (_hasCoords) ...[
            SizedBox(height: AppHeight.s10),
            // Mini static map preview
            GestureDetector(
              onTap: () => openDirections(task.locationLat!, task.locationLng!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.s12),
                child: SizedBox(
                  height: 150.h,
                  width: double.infinity,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter:
                          LatLng(task.locationLat!, task.locationLng!),
                      initialZoom: 14,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.t3afy.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                                task.locationLat!, task.locationLng!),
                            width: 36.r,
                            height: 36.r,
                            child: Icon(
                              Icons.location_pin,
                              color: ColorManager.primary500,
                              size: 36.r,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: AppHeight.s8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: MapButton(
                lat: task.locationLat,
                lng: task.locationLng,
                locationName: task.locationName,
                locationAddress: task.locationAddress,
              ),
            ),
          ] else ...[
            SizedBox(height: AppHeight.s8),
            // Fallback: search by address in Google Maps
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: MapButton(
                lat: task.locationLat,
                lng: task.locationLng,
                locationName: task.locationName,
                locationAddress: task.locationAddress,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
