import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/after_transition.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key, this.initialLocation});

  /// Pre-selected location when editing an existing campaign.
  final LatLng? initialLocation;

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  static const _cairoCenter = LatLng(30.0444, 31.2357);

  late LatLng _selected = widget.initialLocation ?? _cairoCenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'تحديد الموقع',
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: AfterTransition(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _selected,
                    initialZoom: 13,
                    onTap: (_, point) => setState(() => _selected = point),
                  ),
                  children: [
                    AppMapTiles.layer(),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selected,
                          width: 36,
                          height: 36,
                          child: const AppMapPin(),
                        ),
                      ],
                    ),
                    AppMapTiles.attribution(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                Space.gutter,
                Space.vl,
                Space.gutter,
                Space.vl + MediaQuery.paddingOf(context).bottom,
              ),
              decoration: BoxDecoration(
                color: ColorManager.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Radii.sheet),
                ),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'اضغط على الخريطة لوضع العلامة في مكان الحملة',
                    style: AppText.label(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Space.vm),
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
