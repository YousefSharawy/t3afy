import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:url_launcher/url_launcher.dart';

/// canLaunchUrl() is false for https on Android 11+ unless the manifest
/// declares `<queries>` for it (it doesn't), which made these buttons do
/// nothing; so launch directly and fall back when a launch fails.
Future<bool> _tryLaunch(String url) async {
  try {
    return await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {
    return false;
  }
}

Future<void> openDirections(double lat, double lng) async {
  final googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
  final appleMapsUrl = 'https://maps.apple.com/?daddr=$lat,$lng&dirflg=d';
  final geoUrl = 'geo:$lat,$lng?q=$lat,$lng';

  if (await _tryLaunch(googleMapsUrl)) return;
  if (await _tryLaunch(appleMapsUrl)) return;
  await _tryLaunch(geoUrl);
}

class MapButton extends StatelessWidget {
  const MapButton({
    super.key,
    this.lat,
    this.lng,
    this.locationName,
    this.locationAddress,
  });

  final double? lat;
  final double? lng;
  final String? locationName;
  final String? locationAddress;

  bool get _hasCoords => lat != null && lng != null && lat != 0.0 && lng != 0.0;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _openDirections,
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManager.brand,
        side: const BorderSide(color: ColorManager.line),
        minimumSize: Size(0, AppSizes.touch),
        padding: EdgeInsets.symmetric(horizontal: Space.l),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.input),
        ),
      ),
      icon: Icon(_hasCoords ? AppIcons.map : AppIcons.search, size: 18),
      label: Text(
        _hasCoords ? 'الاتجاهات إلى الموقع' : 'بحث في الخريطة',
        style: AppText.label(color: ColorManager.brand),
      ),
    );
  }

  Future<void> _openDirections() async {
    if (_hasCoords) {
      await openDirections(lat!, lng!);
    } else {
      final query = locationName ?? locationAddress ?? '';
      if (query.isEmpty) return;
      await _tryLaunch(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
      );
    }
  }
}
