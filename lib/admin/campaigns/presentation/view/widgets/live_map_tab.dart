import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/base/widgets/after_transition.dart';

/// Live positions of the campaign team.
///
/// Only the latest point per volunteer is fetched (newest 500 rows, deduped)
/// instead of the whole location history. Updates come from realtime inserts
/// for this campaign (coalesced) plus a slow 60 s safety poll. TabBarView only
/// keeps the visible tab alive, so neither runs while another tab is shown.
class LiveMapTab extends StatefulWidget {
  const LiveMapTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  State<LiveMapTab> createState() => _LiveMapTabState();
}

class _LiveMapTabState extends State<LiveMapTab> {
  static const _staleAfter = Duration(minutes: 15);
  static const _siteRadiusMeters = 200.0;

  final _client = Supabase.instance.client;
  final _hub = RealtimeHub(
    debounce: const Duration(milliseconds: 500),
    maxWait: const Duration(seconds: 1),
  );
  Timer? _poll;
  List<_VolunteerPin> _pins = [];
  bool _loading = true;
  bool _fetching = false;

  bool get _hasCoords =>
      widget.detail.locationLat != null &&
      widget.detail.locationLng != null &&
      widget.detail.locationLat != 0 &&
      widget.detail.locationLng != 0;

  @override
  void initState() {
    super.initState();
    if (!_hasCoords) return;
    _fetchPins();
    _hub.watch(
      name: 'live-map',
      table: 'volunteer_locations',
      event: PostgresChangeEvent.insert,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'task_id',
        value: widget.detail.id,
      ),
      onChange: _fetchPins,
    );
    _poll = Timer.periodic(const Duration(seconds: 60), (_) => _fetchPins());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _hub.dispose();
    super.dispose();
  }

  Future<void> _fetchPins() async {
    if (_fetching) return;
    _fetching = true;
    try {
      final raw = await _client
          .from('volunteer_locations')
          .select('user_id, latitude, longitude, recorded_at')
          .eq('task_id', widget.detail.id)
          .order('recorded_at', ascending: false)
          .limit(500);

      final memberMap = {for (final m in widget.detail.members) m.id: m};
      final seen = <String>{};
      final now = DateTime.now();
      final pins = <_VolunteerPin>[];
      for (final row in raw as List) {
        final uid = row['user_id'] as String;
        if (!seen.add(uid)) continue;
        final member = memberMap[uid];
        final at = DateTime.tryParse('${row['recorded_at']}')?.toLocal();
        final checkedIn =
            member?.checkedInAt != null && member?.checkedOutAt == null;
        pins.add(
          _VolunteerPin(
            userId: uid,
            name: member?.name ?? 'متطوع',
            point: LatLng(
              (row['latitude'] as num).toDouble(),
              (row['longitude'] as num).toDouble(),
            ),
            recordedAt: at,
            isLive: checkedIn && at != null && now.difference(at) < _staleAfter,
          ),
        );
      }
      if (mounted) {
        setState(() {
          _pins = pins;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    } finally {
      _fetching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCoords) {
      return const AppEmptyState(
        title: 'لم يتم تحديد موقع لهذه الحملة',
        icon: Icons.location_off_rounded,
      );
    }
    final site = LatLng(widget.detail.locationLat!, widget.detail.locationLng!);
    final live = _pins.where((p) => p.isLive).length;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.vl,
        Space.gutter,
        Space.vxl + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.card),
          child: SizedBox(
            height: 340,
            child: Stack(
              children: [
                AfterTransition(
                  child: FlutterMap(
                    options: MapOptions(initialCenter: site, initialZoom: 15),
                    children: [
                      AppMapTiles.layer(),
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: site,
                            radius: _siteRadiusMeters,
                            useRadiusInMeter: true,
                            color: ColorManager.brand.withValues(alpha: 0.10),
                            borderColor: ColorManager.brand,
                            borderStrokeWidth: 1.5,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: site,
                            width: 36,
                            height: 36,
                            child: const AppMapPin(icon: AppIcons.flag),
                          ),
                          for (final pin in _pins)
                            Marker(
                              point: pin.point,
                              width: 30,
                              height: 30,
                              child: Tooltip(
                                message: pin.name,
                                child: AppMapPin(
                                  color: pin.isLive
                                      ? ColorManager.sprout
                                      : ColorManager.inkFaint,
                                  icon: AppIcons.person,
                                ),
                              ),
                            ),
                        ],
                      ),
                      AppMapTiles.attribution(),
                    ],
                  ),
                ),
                if (_loading)
                  const PositionedDirectional(
                    top: 0,
                    start: 0,
                    end: 0,
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Colors.transparent,
                      color: ColorManager.brand,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: Space.vm),
        Wrap(
          spacing: Space.l,
          runSpacing: Space.vxs,
          children: const [
            _LegendItem(color: ColorManager.sprout, label: 'متواجد الآن'),
            _LegendItem(color: ColorManager.inkFaint, label: 'غير نشط'),
            _LegendItem(color: ColorManager.brand, label: 'موقع الحملة'),
          ],
        ),
        SizedBox(height: Space.vl),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: 'مواقع الفريق',
                trailing: Text(
                  '$live متواجد',
                  style: AppText.label(color: ColorManager.sproutText),
                ),
              ),
              if (_pins.isEmpty && !_loading)
                Text('لا توجد مواقع مسجلة للفريق بعد', style: AppText.label())
              else
                for (final pin in _pins)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Space.vxs),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: pin.isLive
                              ? ColorManager.sprout
                              : ColorManager.inkFaint,
                        ),
                        SizedBox(width: Space.s),
                        Expanded(child: Text(pin.name, style: AppText.body())),
                        if (pin.recordedAt != null)
                          Text(
                            DateAr.timeAgo(pin.recordedAt),
                            style: AppText.caption(),
                          ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        SizedBox(width: Space.xs),
        Text(label, style: AppText.caption(color: ColorManager.inkMuted)),
      ],
    );
  }
}

class _VolunteerPin {
  final String userId;
  final String name;
  final LatLng point;
  final DateTime? recordedAt;
  final bool isLive;

  const _VolunteerPin({
    required this.userId,
    required this.name,
    required this.point,
    required this.recordedAt,
    required this.isLive,
  });
}
