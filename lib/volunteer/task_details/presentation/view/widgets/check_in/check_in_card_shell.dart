import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';

/// The one card style every check-in state uses: tinted icon, title,
/// optional subtitle/trailing, then the state's body and primary action.
class CheckInCardShell extends StatelessWidget {
  const CheckInCardShell({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    this.subtitle,
    this.trailing,
    this.children = const [],
  });

  final IconData icon;
  final Color tone;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      accent: tone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge(icon: icon, color: tone, size: 40),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.bodyStrong()),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: getNumericStyle(
                          fontSize: 13,
                          color: ColorManager.inkMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Task point + 200 m ring. The tiles are built once per task point; only the
/// volunteer dot changes with GPS updates.
class CheckInMiniMap extends StatelessWidget {
  const CheckInMiniMap({
    super.key,
    required this.taskLat,
    required this.taskLng,
    required this.volunteerLat,
    required this.volunteerLng,
    required this.radiusMeters,
  });

  final double taskLat;
  final double taskLng;
  final double volunteerLat;
  final double volunteerLng;
  final double radiusMeters;

  @override
  Widget build(BuildContext context) {
    return AppMapPreview(
      key: ValueKey('checkin-map-$taskLat,$taskLng'),
      point: LatLng(taskLat, taskLng),
      height: 132,
      circleRadiusMeters: radiusMeters,
      extraMarkers: [
        Marker(
          point: LatLng(volunteerLat, volunteerLng),
          width: 16,
          height: 16,
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.info,
              shape: BoxShape.circle,
              border: Border.all(color: ColorManager.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Label / value line in the check-in summaries.
class CheckInSummaryRow extends StatelessWidget {
  const CheckInSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Space.vxs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppText.label())),
          Text(
            value,
            style: getNumericStyle(
              fontSize: strong ? 15 : 14,
              color: strong ? ColorManager.ink : ColorManager.inkMuted,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

String formatCheckInDistance(double metres) {
  if (metres >= 1000) return '${(metres / 1000).toStringAsFixed(1)} كم';
  return '${metres.round()} متر';
}
