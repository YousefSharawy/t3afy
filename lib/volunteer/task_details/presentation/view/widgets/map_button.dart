import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
              'فتح في الخريطة',
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

  Future<void> _openMap() async {
    if (lat != null && lng != null) {
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
