import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/volunteer/maps/widgets/hotspot.dart';
import 'package:t3afy/volunteer/maps/widgets/hotspot_card.dart';
import 'package:t3afy/volunteer/maps/widgets/map_section.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VolunteerMapView extends StatefulWidget {
  const VolunteerMapView({super.key});

  @override
  State<VolunteerMapView> createState() => _VolunteerMapViewState();
}

class _VolunteerMapViewState extends State<VolunteerMapView> {
  final GlobalKey _mapSectionKey = GlobalKey();

  static final LatLng _mapCenter = LatLng(30.0444, 31.2357);

  static final List<Hotspot> _hotspots = [
    Hotspot(
      name: 'مدينة نصر',
      cases: 12,
      severity: HotspotSeverity.high,
      point: LatLng(30.0626, 31.3361),
      radiusMeters: 2800,
    ),
    Hotspot(
      name: 'إمبابة',
      cases: 7,
      severity: HotspotSeverity.medium,
      point: LatLng(30.0702, 31.2089),
      radiusMeters: 2000,
    ),
    Hotspot(
      name: 'شبرا',
      cases: 5,
      severity: HotspotSeverity.medium,
      point: LatLng(30.1128, 31.2428),
      radiusMeters: 1500,
    ),
    Hotspot(
      name: 'التجمع الخامس',
      cases: 2,
      severity: HotspotSeverity.low,
      point: LatLng(30.0131, 31.4731),
      radiusMeters: 1200,
    ),
  ];

  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;

  @override
  void initState() {
    super.initState();
    _tutorialListener = () => _checkTutorial();
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
  }

  @override
  void dispose() {
    TutorialPhaseService.instance.phaseNotifier.removeListener(
      _tutorialListener,
    );
    super.dispose();
  }

  void _checkTutorial() {
    if (!mounted) return;
    final svc = TutorialPhaseService.instance;
    if (!svc.isRunning) return;
    if (svc.currentPhase != 3 || svc.isAdmin) return;
    if (_lastCheckedPhase == 3) return; // Already showed phase 3
    _lastCheckedPhase = 3; // Mark immediately since map renders synchronously
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _showMapTutorial();
    });
  }

  void _showMapTutorial() {
    final targets = <TargetFocus>[];

    if (_mapSectionKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'map_section',
          keyTarget: _mapSectionKey,
          title: 'خريطة المهام',
          description: 'اعرض مواقع جميع مهامك واحصل على اتجاهات الوصول',
          contentAlign: ContentAlign.top,
          stepIndex: 1,
          totalSteps: 1,
        ),
      );
    }

    if (targets.isEmpty) {
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    TutorialService.buildPhaseContinuing(
      targets: targets,
      onFinish: () => TutorialPhaseService.instance.advanceToNextPhase(),
    ).show(context: context, rootOverlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppPageHeader(title: 'الخرائط والموقع', reserveBellSpace: true),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                start: Space.gutter,
                end: Space.gutter,
                top: Space.vs,
                bottom: AppNavShell.bottomInset(context),
              ),
              children: [
                MapSection(
                  key: _mapSectionKey,
                  center: _mapCenter,
                  hotspots: _hotspots,
                ),
                SizedBox(height: Space.vxl),
                const SectionHeader(title: 'نقاط التركيز'),
                for (final h in _hotspots)
                  Padding(
                    key: ValueKey(h.name),
                    padding: EdgeInsets.only(bottom: Space.vm),
                    child: HotspotCard(hotspot: h),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
