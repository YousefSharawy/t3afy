import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/after_transition.dart';

/// One OSM tile configuration for every map in the app.
class AppMapTiles {
  static const url = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const userAgent = 'com.t3afy.app';

  static TileLayer layer() => TileLayer(
    urlTemplate: url,
    userAgentPackageName: userAgent,
    // Keep already-decoded tiles around while panning/rebuilding.
    keepBuffer: 4,
    panBuffer: 1,
  );

  /// Required OSM attribution (small, bottom-start).
  static Widget attribution() => SimpleAttributionWidget(
    source: Text(
      'OpenStreetMap',
      style: AppText.caption(color: ColorManager.inkMuted),
    ),
    backgroundColor: ColorManager.surface.withValues(alpha: 0.8),
  );
}

/// Branded map pin.
class AppMapPin extends StatelessWidget {
  const AppMapPin({
    super.key,
    this.color = ColorManager.brand,
    this.icon = AppIcons.location,
  });
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ColorManager.white, width: 2.5),
        boxShadow: AppShadows.card,
      ),
      child: Icon(icon, color: ColorManager.white, size: 16),
    );
  }
}

/// Static, non-interactive map preview (task / campaign location).
/// Wrapped in a [RepaintBoundary] and built once per [point] so GPS ticks or
/// parent rebuilds don't redraw tiles. Tap opens directions via [onTap].
class AppMapPreview extends StatelessWidget {
  const AppMapPreview({
    super.key,
    required this.point,
    this.height = 160,
    this.zoom = 15,
    this.onTap,
    this.extraMarkers = const [],
    this.circleRadiusMeters,
    this.label,
  });

  final LatLng point;
  final double height;
  final double zoom;
  final VoidCallback? onTap;
  final List<Marker> extraMarkers;
  final double? circleRadiusMeters;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.card),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              AfterTransition(
                child: FlutterMap(
                  key: ValueKey('${point.latitude},${point.longitude}'),
                  options: MapOptions(
                    initialCenter: point,
                    initialZoom: zoom,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    AppMapTiles.layer(),
                    if (circleRadiusMeters != null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: point,
                            radius: circleRadiusMeters!,
                            useRadiusInMeter: true,
                            color: ColorManager.brand.withValues(alpha: 0.12),
                            borderColor: ColorManager.brand,
                            borderStrokeWidth: 1.5,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: 34,
                          height: 34,
                          child: const AppMapPin(),
                        ),
                        ...extraMarkers,
                      ],
                    ),
                    AppMapTiles.attribution(),
                  ],
                ),
              ),
              if (onTap != null)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: onTap),
                  ),
                ),
              if (label != null)
                PositionedDirectional(
                  top: Space.vs,
                  start: Space.s,
                  end: Space.s,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Space.s,
                        vertical: Space.vxs,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.surface,
                        borderRadius: BorderRadius.circular(Radii.chip),
                        boxShadow: AppShadows.card,
                      ),
                      child: Text(
                        label!,
                        style: AppText.label(color: ColorManager.ink),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
