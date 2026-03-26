import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key, this.initialLocation});

  /// Pre-selected location when editing an existing campaign.
  final LatLng? initialLocation;

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  static const _cairoCenter = LatLng(30.0444, 31.2357);

  late LatLng _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocation ?? _cairoCenter;
  }

  void _onTap(TapPosition _, LatLng point) {
    setState(() => _selected = point);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.natural900,
              size: 22.sp,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            'تحديد الموقع',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.natural900,
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Map ─────────────────────────────────────────────────────────
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _selected,
                  initialZoom: 13,
                  onTap: _onTap,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.t3afy.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selected,
                        width: 40.r,
                        height: 40.r,
                        child: Icon(
                          Icons.location_pin,
                          color: ColorManager.primary500,
                          size: 40.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Bottom panel ─────────────────────────────────────────────────
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(
                AppWidth.s18,
                AppHeight.s16,
                AppWidth.s18,
                AppHeight.s24,
              ),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.s16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Coordinates display
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppWidth.s14,
                      vertical: AppHeight.s10,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.natural100,
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                    ),
                    child: Text(
                      'خط العرض: ${_selected.latitude.toStringAsFixed(4)} — خط الطول: ${_selected.longitude.toStringAsFixed(4)}',
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: ColorManager.natural500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppHeight.s12),

                  // Confirm button
                  PrimaryElevatedButton(
                    title: 'تأكيد الموقع',
                    onPress: () => Navigator.of(context).pop(_selected),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
