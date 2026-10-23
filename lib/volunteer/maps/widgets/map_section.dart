import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';
import 'package:t3afy/base/widgets/after_transition.dart';
import 'hotspot.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key, required this.center, required this.hotspots});

  final LatLng center;
  final List<Hotspot> hotspots;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.card),
          child: SizedBox(
            height: 240.h,
            child: RepaintBoundary(
              child: AfterTransition(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 10,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    AppMapTiles.layer(),
                    CircleLayer(
                      circles: [
                        for (final h in hotspots)
                          CircleMarker(
                            point: h.point,
                            radius: h.radiusMeters,
                            useRadiusInMeter: true,
                            color: h.severity.color.withValues(alpha: 0.3),
                            borderColor: h.severity.color.withValues(
                              alpha: 0.75,
                            ),
                            borderStrokeWidth: 2,
                          ),
                      ],
                    ),
                    AppMapTiles.attribution(),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Space.vs),
        const _SeverityLegend(),
      ],
    );
  }
}

class _SeverityLegend extends StatelessWidget {
  const _SeverityLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.l,
      runSpacing: Space.vxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'مستوى التركيز:',
          style: AppText.caption(color: ColorManager.inkMuted),
        ),
        for (final s in HotspotSeverity.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: s.color.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: s.color, width: 1.5),
                ),
              ),
              SizedBox(width: Space.xs),
              Text(
                s.label,
                style: AppText.caption(color: ColorManager.inkMuted),
              ),
            ],
          ),
      ],
    );
  }
}
