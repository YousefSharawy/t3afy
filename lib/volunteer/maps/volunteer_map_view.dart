import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerMapView extends StatelessWidget {
  const VolunteerMapView({super.key});

  // Map center — Cairo, Egypt
  static final LatLng _mapCenter = LatLng(30.0444, 31.2357);

  // Hardcoded hotspot data
  static final List<Map<String, dynamic>> hotspots = [
    {
      'name': 'مدينه نصر',
      'cases': 12,
      'severity': 'عالي',
      'severity_color': const Color(0xffEF4444),
    },
    {
      'name': 'إمبابة',
      'cases': 7,
      'severity': 'متوسط',
      'severity_color': const Color(0xffD97706),
    },
    {
      'name': 'شبرا',
      'cases': 5,
      'severity': 'متوسط',
      'severity_color': const Color(0xffD97706),
    },
    {
      'name': 'التجمع الخامس',
      'cases': 2,
      'severity': 'منخفض',
      'severity_color': const Color(0xff2DD4BF),
    },
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
              // Header with title and notification bell
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
              SizedBox(height: AppHeight.s20),
              // Interactive map with hotspot circles
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.s16),
                child: SizedBox(
                  height: 220.h,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _mapCenter,
                      initialZoom: 10.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.t3afy.app',
                      ),
                      CircleLayer(
                        circles: [
                          // مدينه نصر — عالي (red, large)
                          CircleMarker(
                            point: LatLng(30.0626, 31.3361),
                            radius: 2800,
                            useRadiusInMeter: true,
                            color: Colors.red.withValues(alpha: 0.35),
                            borderColor: Colors.red.withValues(alpha: 0.7),
                            borderStrokeWidth: 2,
                          ),
                          // إمبابة — متوسط (amber)
                          CircleMarker(
                            point: LatLng(30.0702, 31.2089),
                            radius: 2000,
                            useRadiusInMeter: true,
                            color: Colors.amber.withValues(alpha: 0.35),
                            borderColor: Colors.amber.withValues(alpha: 0.7),
                            borderStrokeWidth: 2,
                          ),
                          // شبرا — متوسط (amber)
                          CircleMarker(
                            point: LatLng(30.1128, 31.2428),
                            radius: 1500,
                            useRadiusInMeter: true,
                            color: Colors.amber.withValues(alpha: 0.35),
                            borderColor: Colors.amber.withValues(alpha: 0.7),
                            borderStrokeWidth: 2,
                          ),
                          // التجمع الخامس — منخفض (teal)
                          CircleMarker(
                            point: LatLng(30.0131, 31.4731),
                            radius: 1200,
                            useRadiusInMeter: true,
                            color: const Color(
                              0xFF2DD4BF,
                            ).withValues(alpha: 0.3),
                            borderColor: const Color(
                              0xFF2DD4BF,
                            ).withValues(alpha: 0.7),
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppHeight.s24),
              // Hotspots section title
              Text(
                'نقاط التركيز (Hotspots)',
                textAlign: TextAlign.right,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueOne900,
                  fontSize: FontSize.s16,
                ),
              ),
              SizedBox(height: AppHeight.s12),
              // Hotspot cards list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hotspots.length,
                separatorBuilder: (_, _) => SizedBox(height: AppHeight.s12),
                itemBuilder: (context, index) {
                  final hotspot = hotspots[index];
                  return _buildHotspotCard(hotspot);
                },
              ),
              SizedBox(height: AppHeight.s20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotspotCard(Map<String, dynamic> hotspot) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff0C203B), Color(0xff143764)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s14,
        vertical: AppHeight.s12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink.withValues(alpha: 0.3),
            ),
            child: Center(child: Image.asset(IconAssets.location)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotspot['name'],
                  textAlign: TextAlign.right,
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.white,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: AppHeight.s2),
                Text(
                  '${hotspot['cases']} ${hotspot['cases'] == 1 ? 'حاله مرصودة' : 'حالات مرصودة'}',
                  textAlign: TextAlign.right,
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.lightGray400,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // Severity badge on the left
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s10,
              vertical: AppHeight.s4,
            ),
            decoration: BoxDecoration(
              color: hotspot['severity_color'],
              borderRadius: BorderRadius.circular(AppRadius.s20),
            ),
            child: Text(
              hotspot['severity'],
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.white,
                fontSize: FontSize.s11,
              ),
            ),
          ),

          // Area name and cases count on the right (RTL)

          // Location pin icon on the right
        ],
      ),
    );
  }
}
