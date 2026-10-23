import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';

/// The single severity → color map used by the map circles, the legend and
/// the hotspot cards.
enum HotspotSeverity {
  high('عالي', ColorManager.error, ColorManager.errorLight),
  medium('متوسط', ColorManager.warning, ColorManager.warningLight),
  low('منخفض', ColorManager.info, ColorManager.infoLight);

  const HotspotSeverity(this.label, this.color, this.soft);

  final String label;
  final Color color;
  final Color soft;
}

class Hotspot {
  const Hotspot({
    required this.name,
    required this.cases,
    required this.severity,
    required this.point,
    required this.radiusMeters,
  });

  final String name;
  final int cases;
  final HotspotSeverity severity;
  final LatLng point;
  final double radiusMeters;
}
