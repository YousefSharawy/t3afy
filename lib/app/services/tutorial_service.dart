import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
    phaseNotifier.value = _currentPhase;
  }

  /// Called by each screen's TutorialCoachMark.onFinish to advance to the
  /// next phase and switch to the appropriate tab.
  void advanceToNextPhase() {
    if (!_isRunning) return;
    _currentPhase++;

    final nextTab = _isAdmin
        ? _adminNextTab(_currentPhase)
        : _volunteerNextTab(_currentPhase);
    if (nextTab != null) {
      _switchTab?.call(nextTab);
      // Notify listeners AFTER the tab switch gives the screen time to render.
      // A short delay ensures the already-alive screen's listener fires
      // after goBranch has activated the correct tab.
      Future.delayed(const Duration(milliseconds: 600), () {
        phaseNotifier.value = _currentPhase;
      });
    } else {
      // All phases done — screens handle their own completion overlay.
      _isRunning = false;
      _currentPhase = 0;
      phaseNotifier.value = _currentPhase;
    }
  }

  /// Called when the user taps "تخطي الجولة" on any step.
  void skip() {
    _isRunning = false;
    _currentPhase = 0;
    phaseNotifier.value = _currentPhase;
  }

  /// Called after the very last phase finishes (completion overlay dismissed).
  void complete() {
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
// TargetFocus items, show welcome / completion dialogs. Every step in the app
// uses the same card ([stepCard]) and the same skip pill ([skipWidget]).
// ---------------------------------------------------------------------------
class TutorialService {
  static const _overlayOpacity = 0.82;
  static const _focusDuration = Duration(milliseconds: 300);
  static const _pulseDuration = Duration(milliseconds: 600);

  /// Text style for the skip control, for screens that still pass
  /// `textStyleSkip:` to their own TutorialCoachMark.
  static TextStyle get skipTextStyle =>
      getSemiBoldStyle(fontSize: FontSize.s14, color: ColorManager.brand);

  /// The skip control: a surface pill with brand text. Pass it as
  /// `skipWidget:` to TutorialCoachMark (the package wires the tap to skip).
  static Widget skipWidget({String label = 'تخطي'}) {
    return Padding(
      padding: EdgeInsets.all(Space.l),
      // Sized to its label: a Container with `alignment` would expand to
      // fill the overlay the package gives it (the "giant skip" bug).
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Space.l,
          vertical: Space.vs + 2,
        ),
        decoration: BoxDecoration(
          color: ColorManager.surface,
          borderRadius: BorderRadius.circular(Radii.chip),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text(label, style: skipTextStyle)],
        ),
      ),
    );
  }

  static TutorialCoachMark _coachMark({
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
    required VoidCallback onSkip,
    required String skipLabel,
  }) {
    return TutorialCoachMark(
      targets: targets,
      colorShadow: ColorManager.ink,
      opacityShadow: _overlayOpacity,
      textSkip: skipLabel,
      textStyleSkip: skipTextStyle,
      skipWidget: skipWidget(label: skipLabel),
      alignSkip: AlignmentDirectional.bottomEnd,
      paddingFocus: 10,
      focusAnimationDuration: _focusDuration,
      unFocusAnimationDuration: _focusDuration,
      pulseAnimationDuration: _pulseDuration,
      onFinish: onFinish,
      onSkip: () {
        onSkip();
        return true;
      },
    );
  }

  /// Build a TutorialCoachMark with consistent styling.
  /// Skip ends the whole cross-screen tutorial.
  static TutorialCoachMark buildPhase({
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
  }) {
    return _coachMark(
      targets: targets,
      onFinish: onFinish,
      onSkip: TutorialPhaseService.instance.skip,
      skipLabel: 'تخطي الجولة',
    );
  }

  /// Like [buildPhase] but pressing "تخطي" advances to the NEXT phase instead
  /// of killing the entire tutorial.  Use this for all cross-screen phases so
  /// that tapping skip on one screen still continues the chain.
  /// [onSkip] replaces the default (advance to next phase) when given.
  static TutorialCoachMark buildPhaseContinuing({
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
    VoidCallback? onSkip,
  }) {
    return _coachMark(
      targets: targets,
      onFinish: onFinish,
      onSkip: onSkip ?? TutorialPhaseService.instance.advanceToNextPhase,
      skipLabel: 'تخطي',
    );
  }

  /// The single step card used by every tutorial target: surface card, ink
  /// title, muted body, step counter and a brand "التالي" / "إنهاء" button.
  /// Without a [controller] the card shows text only (no footer).
  static Widget stepCard({
    required String title,
    required String description,
    TutorialCoachMarkController? controller,
    int stepIndex = 1,
    int totalSteps = 1,
  }) {
    final isLast = stepIndex >= totalSteps;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.title()),
          SizedBox(height: Space.vs),
          Text(
            description,
            style: getRegularStyle(
              fontSize: FontSize.s14,
              color: ColorManager.inkMuted,
              height: 1.5,
            ),
          ),
          if (controller != null) ...[
            SizedBox(height: Space.vl),
            Row(
              children: [
                if (totalSteps > 1)
                  Text(
                    '$stepIndex من $totalSteps',
                    style: getNumericStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.inkFaint,
                      fontWeight: FontWeightManager.medium,
                    ),
                  ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: isLast ? controller.skip : controller.next,
                  style: FilledButton.styleFrom(
                    backgroundColor: ColorManager.brand,
                    foregroundColor: ColorManager.white,
                    minimumSize: Size(0, AppSizes.touch - Space.s),
                    padding: EdgeInsets.symmetric(horizontal: Space.l),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.input),
                    ),
                    textStyle: getSemiBoldStyle(
                      fontSize: FontSize.s14,
                      color: ColorManager.white,
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: Icon(
                    isLast ? AppIcons.done : AppIcons.chevron,
                    size: AppSizes.iconM,
                  ),
                  label: Text(isLast ? 'إنهاء' : 'التالي'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build a TargetFocus for a single tutorial step.
  ///
  /// [contentAlign] — where the tooltip card is placed relative to the target.
  ///   Use [ContentAlign.bottom] for widgets in the upper half of the screen,
  ///   [ContentAlign.top] for widgets near the bottom (nav bar, lower content).
  /// Puts the step card on whichever side of the target has room: below
  /// targets in the upper half of the screen, above the rest. Prevents the
  /// card being pushed under the status bar (e.g. the map near the top).
  static ContentAlign _fitAlign(GlobalKey key, ContentAlign fallback) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return fallback;
    final screenH = MediaQuery.sizeOf(key.currentContext!).height;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;
    final roomAbove = top;
    final roomBelow = screenH - bottom;
    return roomBelow >= roomAbove ? ContentAlign.bottom : ContentAlign.top;
  }

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
          align: _fitAlign(keyTarget, contentAlign),
          padding: EdgeInsets.symmetric(
            horizontal: Space.gutter,
            vertical: Space.vm,
          ),
          builder: (context, controller) => stepCard(
            title: title,
            description: description,
            controller: controller,
            stepIndex: stepIndex,
            totalSteps: totalSteps,
          ),
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
    return _coachMark(
      targets: targets,
      onFinish: onFinish,
      onSkip: onSkip,
      skipLabel: 'تخطي الجولة',
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
  // Welcome / completion overlays
  // -------------------------------------------------------------------------
  static Widget _overlayDialog({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String body,
    required List<Widget> actions,
  }) {
    return Dialog(
      backgroundColor: ColorManager.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      // Scrolls instead of overflowing on short screens / large text.
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(Space.xl, Space.vxl, Space.xl, Space.vl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.touch + Space.l,
              height: AppSizes.touch + Space.l,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: AppSizes.iconL + Space.xs,
              ),
            ),
            SizedBox(height: Space.vl),
            Text(title, textAlign: TextAlign.center, style: AppText.headline()),
            SizedBox(height: Space.vs),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppText.body(color: ColorManager.inkMuted),
            ),
            SizedBox(height: Space.vxl),
            ...actions,
          ],
        ),
      ),
    );
  }

  static Future<bool?> showWelcomeOverlay(
    BuildContext context, {
    required bool isAdmin,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _overlayDialog(
        icon: AppIcons.vol,
        iconColor: ColorManager.brand,
        iconBackground: ColorManager.brandSoft,
        title: 'مرحباً بك في تعافي',
        body:
            'هل تريد جولة تعريفية سريعة في التطبيق؟ سنأخذك في جولة عبر جميع الشاشات',
        actions: [
          PrimaryElevatedButton(
            width: double.infinity,
            title: 'ابدأ الجولة',
            onPress: () => Navigator.of(context).pop(true),
          ),
          SizedBox(height: Space.vxs),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              minimumSize: Size(double.infinity, AppSizes.touch),
            ),
            child: Text(
              'تخطي',
              style: getSemiBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showCompletionOverlay(
    BuildContext context, {
    required bool isAdmin,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _overlayDialog(
        icon: AppIcons.done2,
        iconColor: ColorManager.sproutText,
        iconBackground: ColorManager.sproutSoft,
        title: 'أنت جاهز!',
        body: isAdmin
            ? 'الآن يمكنك إدارة المتطوعين والحملات. بالتوفيق!'
            : 'الآن يمكنك تصفح مهامك وبدء رحلة التطوع. بالتوفيق!',
        actions: [
          PrimaryElevatedButton(
            width: double.infinity,
            title: 'ابدأ الآن',
            onPress: () {
              Navigator.of(context).pop();
              onDone();
            },
          ),
          SizedBox(height: Space.vs),
        ],
      ),
    );
  }
}
