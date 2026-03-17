import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class MapButton extends StatelessWidget {
  const MapButton({super.key, required this.lat, required this.lng});

  final double? lat;
  final double? lng;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s12,
          vertical: AppHeight.s6,
        ),
        decoration: BoxDecoration(
          color: ColorManager.cyanPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.s8),
          border: Border.all(
            color: ColorManager.cyanPrimary.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'فتح في الخريطة',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.cyanPrimary,
              ),
            ),
            SizedBox(width: AppWidth.s6),
            Icon(Icons.map_rounded, color: ColorManager.cyanPrimary, size: 16.r),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap() async {
    if (lat != null && lng != null) {
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
