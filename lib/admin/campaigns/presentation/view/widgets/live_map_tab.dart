import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';

class LiveMapTab extends StatefulWidget {
  const LiveMapTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  State<LiveMapTab> createState() => _LiveMapTabState();
}

class _LiveMapTabState extends State<LiveMapTab> {
  final _client = Supabase.instance.client;
  List<_VolunteerPin> _pins = [];
  bool _loading = true;
  Timer? _refreshTimer;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchPins();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetchPins(),
    );
    _channel = _client
        .channel('live_map_${widget.detail.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'volunteer_locations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'task_id',
            value: widget.detail.id,
          ),
          callback: (_) => _fetchPins(),
        )
        .subscribe();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    if (_channel != null) _client.removeChannel(_channel!);
    super.dispose();
  }

  Future<void> _fetchPins() async {
    try {
      // Get latest location per volunteer for this task
      final raw = await _client
          .from('volunteer_locations')
          .select('user_id, latitude, longitude, recorded_at')
          .eq('task_id', widget.detail.id)
          .order('recorded_at', ascending: false);

      // Deduplicate — keep only the latest entry per user
      final seen = <String>{};
      final deduped = <Map<String, dynamic>>[];
      for (final row in raw as List) {
        final uid = row['user_id'] as String;
        if (seen.add(uid)) {
          deduped.add(row as Map<String, dynamic>);
        }
      }

      // Match with member info
      final memberMap = {for (final m in widget.detail.members) m.id: m};
      final pins = deduped.map((row) {
        final uid = row['user_id'] as String;
        final member = memberMap[uid];
        return _VolunteerPin(
          userId: uid,
          name: member?.name ?? 'متطوع',
          lat: (row['latitude'] as num).toDouble(),
          lng: (row['longitude'] as num).toDouble(),
          isCheckedIn:
              member?.checkedInAt != null && member?.checkedOutAt == null,
        );
      }).toList();

      if (mounted) {
        setState(() {
          _pins = pins;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCoords =
        widget.detail.locationLat != null &&
        widget.detail.locationLng != null &&
        widget.detail.locationLat != 0 &&
        widget.detail.locationLng != 0;

    if (!hasCoords) {
      return _NoLocationBody();
    }

    return ListView(
      padding: EdgeInsets.all(AppSize.s16),
      children: [
        _buildMap(),
        SizedBox(height: AppHeight.s16),
        _buildLegend(),
        SizedBox(height: AppHeight.s80),
      ],
    );
  }

  Widget _buildMap() {
    final taskLat = widget.detail.locationLat!;
    final taskLng = widget.detail.locationLng!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.s16),
      child: SizedBox(
        height: 350.h,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(taskLat, taskLng),
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.t3afy.app',
                ),
                // 200m radius circle
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(taskLat, taskLng),
                      radius: 200,
                      useRadiusInMeter: true,
                      color: ColorManager.primary500.withValues(alpha: 0.08),
                      borderColor: ColorManager.primary500.withValues(
                        alpha: 0.4,
                      ),
                      borderStrokeWidth: 1.5,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    // Task location pin
                    Marker(
                      point: LatLng(taskLat, taskLng),
                      width: 36.r,
                      height: 36.r,
                      child: Icon(
                        Icons.location_pin,
                        color: ColorManager.primary500,
                        size: 36.r,
                      ),
                    ),
                    // Volunteer dots
                    ..._pins.map(
                      (pin) => Marker(
                        point: LatLng(pin.lat, pin.lng),
                        width: 60.r,
                        height: 40.r,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: pin.isCheckedIn
                                    ? ColorManager.success
                                    : ColorManager.natural400,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.s4,
                                ),
                              ),
                              child: Text(
                                pin.name.split(' ').first,
                                style: getBoldStyle(
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontSize.s8,
                                  color: ColorManager.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: 10.r,
                              height: 10.r,
                              decoration: BoxDecoration(
                                color: pin.isCheckedIn
                                    ? ColorManager.success
                                    : ColorManager.natural400,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Loading overlay
            if (_loading)
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary500,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المتطوعون النشطون',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s13,
                  color: ColorManager.natural900,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _fetchPins();
                  context.read<CampaignDetailCubit>().load(widget.detail.id);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 14.r,
                      color: ColorManager.primary500,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'تحديث',
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s11,
                        color: ColorManager.primary500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s12),
          if (_pins.isEmpty && !_loading)
            Text(
              'لا يوجد متطوعين في الموقع حالياً',
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.natural400,
              ),
            )
          else
            ..._pins.map((pin) => _PinRow(pin: pin)),
          SizedBox(height: AppHeight.s8),
          Row(
            children: [
              _LegendDot(color: ColorManager.success),
              SizedBox(width: 6.w),
              Text(
                'متواجد الآن',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.natural500,
                ),
              ),
              SizedBox(width: AppWidth.s16),
              _LegendDot(color: ColorManager.natural400),
              SizedBox(width: 6.w),
              Text(
                'غير نشط',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.natural500,
                ),
              ),
              SizedBox(width: AppWidth.s16),
              _LegendDot(color: ColorManager.primary500),
              SizedBox(width: 6.w),
              Text(
                'موقع المهمة',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: ColorManager.natural500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoLocationBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: ColorManager.natural300,
            ),
            SizedBox(height: AppHeight.s12),
            Text(
              'لم يتم تحديد موقع لهذه الحملة',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PinRow extends StatelessWidget {
  const _PinRow({required this.pin});
  final _VolunteerPin pin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s8),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: pin.isCheckedIn
                  ? ColorManager.success
                  : ColorManager.natural400,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            pin.name,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _VolunteerPin {
  final String userId;
  final String name;
  final double lat;
  final double lng;
  final bool isCheckedIn;

  const _VolunteerPin({
    required this.userId,
    required this.name,
    required this.lat,
    required this.lng,
    required this.isCheckedIn,
  });
}
