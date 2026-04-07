import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ---------------------------------------------------------------------------
// GlobalKeys — one per tutorial target widget, declared at app-level so they
// persist across rebuilds and tab switches.
// ---------------------------------------------------------------------------
class AppTutorialKeys {
  // Volunteer shared keys (nav bar / top bar)
  static final GlobalKey volunteerNotificationKey = GlobalKey(
    debugLabel: 'vol_notif',
  );
  static final GlobalKey volunteerHomeTabKey = GlobalKey(
    debugLabel: 'vol_home_tab',
  );
  static final GlobalKey volunteerTasksTabKey = GlobalKey(
    debugLabel: 'vol_tasks_tab',
  );
  static final GlobalKey volunteerMapTabKey = GlobalKey(
    debugLabel: 'vol_map_tab',
  );
  static final GlobalKey volunteerPerformanceTabKey = GlobalKey(
    debugLabel: 'vol_perf_tab',
  );
  static final GlobalKey volunteerBotTabKey = GlobalKey(
    debugLabel: 'vol_bot_tab',
  );

  // Admin shared keys (nav bar / top bar)
  static final GlobalKey adminNotificationKey = GlobalKey(
    debugLabel: 'admin_notif',
  );
  static final GlobalKey adminHomeTabKey = GlobalKey(
    debugLabel: 'admin_home_tab',
  );
  static final GlobalKey adminVolunteersTabKey = GlobalKey(
    debugLabel: 'admin_vol_tab',
  );
  static final GlobalKey adminCampaignsTabKey = GlobalKey(
    debugLabel: 'admin_camp_tab',
  );
  static final GlobalKey adminReportsTabKey = GlobalKey(
    debugLabel: 'admin_rep_tab',
  );
  static final GlobalKey adminPerformanceTabKey = GlobalKey(
    debugLabel: 'admin_perf_tab',
  );

  // Task Details Keys
  static final GlobalKey taskDetailsHeaderKey = GlobalKey();
  static final GlobalKey taskDetailsTabSwitcherKey = GlobalKey();
  static final GlobalKey taskDetailsLocationKey = GlobalKey();
  static final GlobalKey taskDetailsReportKey = GlobalKey();

  // Create Campaign Keys
  static final GlobalKey createCampaignGeneralKey = GlobalKey();
  static final GlobalKey createCampaignDateKey = GlobalKey();
  static final GlobalKey createCampaignLocationKey = GlobalKey();
  static final GlobalKey createCampaignVolunteersKey = GlobalKey();
  static final GlobalKey createCampaignPapersKey = GlobalKey();
}

// ---------------------------------------------------------------------------
// TutorialPhaseService — singleton that coordinates the phased cross-screen
// tutorial.  Each screen checks isRunning + currentPhase in its initState
// and starts its own TutorialCoachMark when it is its turn.
// ---------------------------------------------------------------------------
class TutorialPhaseService {
  TutorialPhaseService._();
  static final TutorialPhaseService instance = TutorialPhaseService._();

  bool _isRunning = false;
  int _currentPhase = 0; // 0 = not started / done, 1..N = active phase
  bool _isAdmin = false;

  /// Fires whenever [_currentPhase] changes so that already-alive screens
  /// (StatefulShellRoute keeps them alive) can react without relying on
  /// initState, which only fires once.
  final ValueNotifier<int> phaseNotifier = ValueNotifier<int>(0);

  /// Callback set by the active shell to switch tabs programmatically.
  void Function(int tabIndex)? _switchTab;

  bool get isRunning => _isRunning;
  int get currentPhase => _currentPhase;
  bool get isAdmin => _isAdmin;

  /// Called by the shell widget once it is mounted, to register the tab-switch
  /// callback.  Must be called before [start].
  void registerSwitchTab(void Function(int tabIndex) cb) {
    _switchTab = cb;
  }

  void unregisterSwitchTab() {
    _switchTab = null;
  }

  /// Start the tutorial at phase 1.  Called after the user taps "ابدأ الجولة"
  /// in the welcome overlay.
  void start({required bool isAdmin}) {
    _isAdmin = isAdmin;
    _isRunning = true;
    _currentPhase = 1;
    debugPrint('📘 TUTORIAL: Started — isAdmin=$isAdmin, phase=1');
    phaseNotifier.value = _currentPhase;
  }

  /// Called by each screen's TutorialCoachMark.onFinish to advance to the
  /// next phase and switch to the appropriate tab.
  void advanceToNextPhase() {
    if (!_isRunning) return;
    final fromPhase = _currentPhase;
    _currentPhase++;
    debugPrint('📘 TUTORIAL: Advancing from phase $fromPhase → $_currentPhase');

    final nextTab = _isAdmin
        ? _adminNextTab(_currentPhase)
        : _volunteerNextTab(_currentPhase);
    if (nextTab != null) {
      debugPrint(
        '📘 TUTORIAL: Switching to tab $nextTab for phase $_currentPhase',
      );
      _switchTab?.call(nextTab);
      // Notify listeners AFTER the tab switch gives the screen time to render.
      // A short delay ensures the already-alive screen's listener fires
      // after goBranch has activated the correct tab.
      Future.delayed(const Duration(milliseconds: 600), () {
        debugPrint('📘 TUTORIAL: Notifying listeners — phase=$_currentPhase');
        phaseNotifier.value = _currentPhase;
      });
    } else {
      // All phases done — screens handle their own completion overlay.
      debugPrint('📘 TUTORIAL: All phases done, marking complete');
      _isRunning = false;
      _currentPhase = 0;
      phaseNotifier.value = _currentPhase;
    }
  }

  /// Called when the user taps "تخطي الجولة" on any step.
  void skip() {
    debugPrint('📘 TUTORIAL: Skipped at phase $_currentPhase');
    _isRunning = false;
    _currentPhase = 0;
    phaseNotifier.value = _currentPhase;
  }

  /// Called after the very last phase finishes (completion overlay dismissed).
  void complete() {
    debugPrint('📘 TUTORIAL: Completed');
    _isRunning = false;
    _currentPhase = 0;
    phaseNotifier.value = _currentPhase;
  }

  // Volunteer: phases 1-5, tab indices 0-4
  // Phase 6 = completion (no tab switch needed — handled in phase 5's onFinish)
  int? _volunteerNextTab(int phase) {
    switch (phase) {
      case 2:
        return 1; // Tasks
      case 3:
        return 2; // Map
      case 4:
        return 3; // Performance
      case 5:
        return 4; // Bot
      default:
        return null; // phase 6+ → done
    }
  }

  // Admin: phases 1-5, tab indices 0-4
  int? _adminNextTab(int phase) {
    switch (phase) {
      case 2:
        return 1; // Volunteers
      case 3:
        return 2; // Campaigns
      case 4:
        return 3; // Reports
      case 5:
        return 4; // Performance
      default:
        return null; // done
    }
  }
}

// ---------------------------------------------------------------------------
// TutorialService — static helpers: build TutorialCoachMark instances, build
// TargetFocus items, show welcome / completion dialogs.
// ---------------------------------------------------------------------------
class TutorialService {
  /// Build a TutorialCoachMark with consistent styling.
  /// [onFinish] and [onSkip] are wired to the phase service automatically.
  static TutorialCoachMark buildPhase({
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
  }) {
    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      textSkip: "تخطي الجولة",
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 600),
      textStyleSkip: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s14,
        fontFamily: FontConstants.fontFamily,
      ),
      onFinish: onFinish,
      onSkip: () {
        TutorialPhaseService.instance.skip();
        return true;
      },
    );
  }

  /// Like [buildPhase] but pressing "تخطي" advances to the NEXT phase instead
  /// of killing the entire tutorial.  Use this for all cross-screen phases so
  /// that tapping skip on one screen still continues the chain.
  static TutorialCoachMark buildPhaseContinuing({
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
  }) {
    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      textSkip: "تخطي",
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 600),
      textStyleSkip: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s14,
        fontFamily: FontConstants.fontFamily,
      ),
      onFinish: onFinish,
      onSkip: () {
        // Advance the chain — don't kill it.
        TutorialPhaseService.instance.advanceToNextPhase();
        return true;
      },
    );
  }

  /// Build a TargetFocus for a single tutorial step.
  ///
  /// [contentAlign] — where the tooltip card is placed relative to the target.
  ///   Use [ContentAlign.bottom] for widgets in the upper half of the screen,
  ///   [ContentAlign.top] for widgets near the bottom (nav bar, lower content).
  static TargetFocus buildTarget({
    required String identify,
    required GlobalKey keyTarget,
    required String title,
    required String description,
    required ContentAlign contentAlign,
    required int stepIndex,
    required int totalSteps,
    ShapeLightFocus shape = ShapeLightFocus.RRect,
    double radius = 12,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      shape: shape,
      radius: radius,
      paddingFocus: 10,
      enableOverlayTab: false,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: contentAlign,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          builder: (context, controller) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: getSemiBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s16,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                  SizedBox(height: AppHeight.s8),
                  Text(
                    description,
                    style: getRegularStyle(
                      color: ColorManager.white.withValues(alpha: 0.85),
                      fontSize: FontSize.s13,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                  SizedBox(height: AppHeight.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$totalSteps / $stepIndex',
                        style: getRegularStyle(
                          color: ColorManager.white.withValues(alpha: 0.45),
                          fontSize: FontSize.s11,
                          fontFamily: FontConstants.fontFamily,
                        ),
                      ),
                      if (stepIndex < totalSteps)
                        GestureDetector(
                          onTap: controller.next,
                          child: Row(
                            children: [
                              Text(
                                'التالي',
                                style: getSemiBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s14,
                                  fontFamily: FontConstants.fontFamily,
                                ),
                              ),
                              SizedBox(width: AppWidth.s4),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorManager.white,
                                size: 13.r,
                              ),
                            ],
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: controller.skip,
                          child: Text(
                            'إنهاء',
                            style: getSemiBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s14,
                              fontFamily: FontConstants.fontFamily,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Legacy helpers — used by task_details_view and create_campaign_view for
  // their own local (single-screen) tutorials that don't participate in the
  // phased cross-screen flow.
  // -------------------------------------------------------------------------

  /// Creates a standalone TutorialCoachMark for local (single-screen) use.
  static TutorialCoachMark createTutorial({
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
    required VoidCallback onSkip,
  }) {
    return TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      textSkip: 'تخطي الجولة',
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      textStyleSkip: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s14,
        fontFamily: FontConstants.fontFamily,
      ),
      onFinish: onFinish,
      onSkip: () {
        onSkip();
        return true;
      },
    );
  }

  /// Creates a TargetFocus using the legacy positional API.
  /// [contentPosition]: 0 = ContentAlign.top, 1 = ContentAlign.bottom
  static TargetFocus createTarget({
    required String identify,
    required GlobalKey keyTarget,
    required String title,
    required String description,
    required int contentPosition,
    ShapeLightFocus shape = ShapeLightFocus.RRect,
    int stepIndex = 1,
    int totalSteps = 1,
  }) {
    return buildTarget(
      identify: identify,
      keyTarget: keyTarget,
      title: title,
      description: description,
      contentAlign: contentPosition == 0
          ? ContentAlign.top
          : ContentAlign.bottom,
      shape: shape,
      stepIndex: stepIndex,
      totalSteps: totalSteps,
    );
  }

  // -------------------------------------------------------------------------
  // Welcome overlay
  // -------------------------------------------------------------------------
  static Future<bool?> showWelcomeOverlay(
    BuildContext context, {
    required bool isAdmin,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppHeight.s16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s24,
              vertical: AppHeight.s24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مرحباً في تعافي! 👋',
                  style: getSemiBoldStyle(
                    color: ColorManager.cyanPrimary,
                    fontSize: FontSize.s20,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s12),
                Text(
                  'هل تريد جولة تعريفية سريعة في التطبيق؟ سنأخذك في جولة عبر جميع الشاشات',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s14,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'تخطي',
                        style: getRegularStyle(
                          color: ColorManager.grey,
                          fontSize: FontSize.s14,
                          fontFamily: FontConstants.fontFamily,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.cyanPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppHeight.s8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'ابدأ الجولة',
                        style: getSemiBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s14,
                          fontFamily: FontConstants.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Completion overlay
  // -------------------------------------------------------------------------
  static void showCompletionOverlay(
    BuildContext context, {
    required bool isAdmin,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppHeight.s16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s24,
              vertical: AppHeight.s24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'أنت جاهز! 🎉',
                  style: getSemiBoldStyle(
                    color: ColorManager.cyanPrimary,
                    fontSize: FontSize.s20,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s12),
                Text(
                  isAdmin
                      ? 'الآن يمكنك إدارة المتطوعين والحملات. بالتوفيق!'
                      : 'الآن يمكنك تصفح مهامك وبدء رحلة التطوع. بالتوفيق!',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s14,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.cyanPrimary,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppHeight.s8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDone();
                  },
                  child: Text(
                    'ابدأ الآن',
                    style: getSemiBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s16,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
