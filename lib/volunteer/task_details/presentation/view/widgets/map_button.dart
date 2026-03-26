import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

Future<void> openDirections(double lat, double lng) async {
  final googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
  final appleMapsUrl = 'https://maps.apple.com/?daddr=$lat,$lng&dirflg=d';
  final geoUrl = 'geo:$lat,$lng?q=$lat,$lng';

  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication);
  } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
    await launchUrl(Uri.parse(appleMapsUrl),
        mode: LaunchMode.externalApplication);
  } else {
    await launchUrl(Uri.parse(geoUrl), mode: LaunchMode.externalApplication);
  }
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
    return GestureDetector(
      onTap: _openDirections,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s10,
          vertical: AppHeight.s4,
        ),
        decoration: BoxDecoration(
          color: ColorManager.primary600,
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(IconAssets.map),
            SizedBox(width: AppWidth.s4),
            Text(
              _hasCoords ? 'الاتجاهات إلى الموقع 🧭' : 'بحث في الخريطة 🔍',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDirections() async {
    if (_hasCoords) {
      await openDirections(lat!, lng!);
    } else {
      final query = locationName ?? locationAddress ?? '';
      if (query.isEmpty) return;
      final searchUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
      if (await canLaunchUrl(searchUrl)) {
        await launchUrl(searchUrl, mode: LaunchMode.externalApplication);
      }
    }
  }
}
