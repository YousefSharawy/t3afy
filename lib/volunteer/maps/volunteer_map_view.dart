import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/maps/widgets/hotspot_card.dart';
import 'package:t3afy/volunteer/maps/widgets/map_section.dart';

class VolunteerMapView extends StatelessWidget {
  const VolunteerMapView({super.key});

  static final LatLng _mapCenter = LatLng(30.0444, 31.2357);

  static const List<Map<String, dynamic>> _hotspots = [
    {'name': 'مدينه نصر', 'cases': 12, 'severity': 'عالي'},
    {'name': 'إمبابة', 'cases': 7, 'severity': 'متوسط'},
    {'name': 'شبرا', 'cases': 5, 'severity': 'متوسط'},
    {'name': 'التجمع الخامس', 'cases': 2, 'severity': 'منخفض'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppHeight.s10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'الخرائط والموقع',
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blueOne900,
                        fontSize: FontSize.s18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppHeight.s24),
              MapSection(center: _mapCenter),
              SizedBox(height: AppHeight.s16),
              Text(
                'نقاط التركيز (Hotspots)',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.natural900,
                  fontSize: FontSize.s14,
                ),
              ),
              SizedBox(height: AppHeight.s8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _hotspots.length,
                separatorBuilder: (_, _) => SizedBox(height: AppHeight.s12),
                itemBuilder: (context, index) {
                  final h = _hotspots[index];
                  return HotspotCard(
                    name: h['name'] as String,
                    cases: h['cases'] as int,
                    severity: h['severity'] as String,
                  );
                },
              ),
              SizedBox(height: AppHeight.s20),
            ],
          ),
        ),
      ),
    );
  }
}
