import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
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

  static const List<Map<String, dynamic>> _hotspots = [
    {'name': 'مدينه نصر', 'cases': 12, 'severity': 'عالي'},
    {'name': 'إمبابة', 'cases': 7, 'severity': 'متوسط'},
    {'name': 'شبرا', 'cases': 5, 'severity': 'متوسط'},
    {'name': 'التجمع الخامس', 'cases': 2, 'severity': 'منخفض'},
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

    debugPrint('📘 TUTORIAL: Map screen starting phase 3, marking _lastCheckedPhase=3');
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
      debugPrint(
        '📘 TUTORIAL: VolunteerMap screen has no targets, advancing to next phase',
      );
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      textSkip: "تخطي",
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 600),
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontConstants.fontFamily),
      onFinish: () => TutorialPhaseService.instance.advanceToNextPhase(),
      onSkip: () {
        TutorialPhaseService.instance.advanceToNextPhase(); // Continue chain, don't kill it
        return true;
      },
    ).show(context: context, rootOverlay: true);
  }

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
              MapSection(key: _mapSectionKey, center: _mapCenter),
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
                separatorBuilder: (_, i) => SizedBox(height: AppHeight.s12),
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
