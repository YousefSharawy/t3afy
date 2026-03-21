import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key, required this.center});

  final LatLng center;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.s16),
      child: SizedBox(
        height: AppHeight.s238,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 10,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.t3afy.app',
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: LatLng(30.0626, 31.3361),
                  radius: 2800,
                  useRadiusInMeter: true,
                  color: Colors.red.withValues(alpha: 0.35),
                  borderColor: Colors.red.withValues(alpha: 0.7),
                  borderStrokeWidth: 2,
                ),
                CircleMarker(
                  point: LatLng(30.0702, 31.2089),
                  radius: 2000,
                  useRadiusInMeter: true,
                  color: Colors.amber.withValues(alpha: 0.35),
                  borderColor: Colors.amber.withValues(alpha: 0.7),
                  borderStrokeWidth: 2,
                ),
                CircleMarker(
                  point: LatLng(30.1128, 31.2428),
                  radius: 1500,
                  useRadiusInMeter: true,
                  color: Colors.amber.withValues(alpha: 0.35),
                  borderColor: Colors.amber.withValues(alpha: 0.7),
                  borderStrokeWidth: 2,
                ),
                CircleMarker(
                  point: LatLng(30.0131, 31.4731),
                  radius: 1200,
                  useRadiusInMeter: true,
                  color: const Color(0xFF2DD4BF).withValues(alpha: 0.3),
                  borderColor: const Color(0xFF2DD4BF).withValues(alpha: 0.7),
                  borderStrokeWidth: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
