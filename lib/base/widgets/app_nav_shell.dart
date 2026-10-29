import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/core/data/realtime_hub.dart';

class NavDestination {
  const NavDestination({required this.icon, required this.label, this.key});
  final IconData icon;
  final String label;
  final GlobalKey? key;
}

/// Live unread-notifications count for the bell. One `count` query on start
/// and on every change to the user's notes (debounced), instead of downloading
/// every unread row from inside the widget.
class UnreadBadge extends ValueNotifier<int> {
  UnreadBadge({required this.isAdmin}) : super(0);

  final bool isAdmin;
  RealtimeHub? _hub;

  Future<void> start() async {
    final uid = LocalAppStorage.getUserId();
    if (uid == null) return;
    await refresh();
    _hub = RealtimeHub()
      ..watch(
        name: 'unread-badge',
        table: 'admin_notes',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'volunteer_id',
          value: uid,
        ),
        ignore: (p) => isAdmin && _otherAdmin(p.newRecord, uid),
        onPayload: _bumpFromPayload,
        onChange: refresh,
      )
      // Deleted notes (cleared inbox): deletes can't be filtered server-side.
      ..watch(
        name: 'unread-badge-del',
        table: 'admin_notes',
        event: PostgresChangeEvent.delete,
        ignore: (p) => deletedRowNotFor(p, 'volunteer_id', uid),
        onChange: refresh,
      );
  }

  static bool _otherAdmin(Map<String, dynamic> row, String uid) {
    final a = row['admin_id'];
    return a != null && '$a' != uid;
  }

  /// A new unread note bumps the badge at once; the debounced count query
  /// still runs afterwards to stay exact.
  bool _bumpFromPayload(PostgresChangePayload p) {
    if (p.eventType == PostgresChangeEvent.insert &&
        p.newRecord['is_read'] != true) {
      value = value + 1;
    }
    return false;
  }

  Future<void> refresh() async {
    final uid = LocalAppStorage.getUserId();
    if (uid == null) return;
    try {
      var q = Supabase.instance.client
          .from('admin_notes')
          .select('id')
          .eq('volunteer_id', uid)
          .eq('is_read', false);
      if (isAdmin) q = q.eq('admin_id', uid);
      final res = await q.count(CountOption.exact);
      value = res.count;
    } catch (_) {}
  }

  @override
  void dispose() {
    _hub?.dispose();
    super.dispose();
  }
}

/// One floating navigation shell for both roles (Volunteer + Manager/مشرف).
///
/// * Active item: tinted icon on a soft brand pill + bold label.
/// * Re-tapping the active tab returns that branch to its root.
/// * Floating bell (end side) with a live unread badge.
/// * Screens add [AppNavShell.bottomInset] as bottom padding so the last item
///   is never hidden behind the bar, and [AppNavShell.bellReserve] on the
///   header's end side (see AppPageHeader.reserveBellSpace).
class AppNavShell extends StatefulWidget {
  const AppNavShell({
    super.key,
    required this.navigationShell,
    required this.destinations,
    required this.notificationsRoute,
    required this.isAdmin,
    this.bellKey,
  });

  final StatefulNavigationShell navigationShell;
  final List<NavDestination> destinations;
  final String notificationsRoute;
  final bool isAdmin;
  final GlobalKey? bellKey;

  static double get barHeight => 64.h;
  static double get _barBottom => 12.h;

  /// Bottom padding every tab's scrollable content should add.
  static double bottomInset(BuildContext context) =>
      barHeight + _barBottom + MediaQuery.paddingOf(context).bottom + 16.h;

  /// Width reserved in headers for the floating bell.
  static double get bellReserve => 52.w;

  @override
  State<AppNavShell> createState() => _AppNavShellState();
}

class _AppNavShellState extends State<AppNavShell> {
  late final UnreadBadge _badge = UnreadBadge(isAdmin: widget.isAdmin);

  @override
  void initState() {
    super.initState();
    _badge.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TutorialPhaseService.instance.registerSwitchTab(
          (index) =>
              widget.navigationShell.goBranch(index, initialLocation: false),
        );
      }
    });
  }

  @override
  void dispose() {
    _badge.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    HapticFeedback.selectionClick();
    final current = widget.navigationShell.currentIndex;
    widget.navigationShell.goBranch(index, initialLocation: index == current);
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    // Dark status-bar icons by default; a screen with a dark header (Manager
    // home) overrides this with its own AnnotatedRegion while it's visible.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: ColorManager.canvas,
        body: Stack(
          children: [
            Positioned.fill(child: widget.navigationShell),
            PositionedDirectional(
              top: MediaQuery.paddingOf(context).top + 8.h,
              end: Space.gutter,
              child: _Bell(
                key: widget.bellKey,
                badge: _badge,
                onTap: () async {
                  await context.push(widget.notificationsRoute);
                  _badge.refresh();
                },
              ),
            ),
            PositionedDirectional(
              start: Space.gutter,
              end: Space.gutter,
              bottom:
                  AppNavShell._barBottom +
                  (safeBottom > 0 ? safeBottom - 8.h : 8.h),
              child: _NavBar(
                destinations: widget.destinations,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: _onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.destinations,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onTap;

  // Fixed item geometry so the sliding pill lines up with every icon.
  static double get _pillW => 52.w;
  static double get _pillH => 30.h;
  // Never shorter than one line of the label at the current text scale, so
  // short screens (.h shrinks) don't clip it.
  static double _labelH(BuildContext context) => math.max(
    16.h,
    MediaQuery.textScalerOf(context).scale(FontSize.s11) * 1.3,
  );
  static double get _gap => 2.h;

  @override
  Widget build(BuildContext context) {
    final contentH = _pillH + _gap + _labelH(context);
    return Container(
      height: AppNavShell.barHeight,
      padding: EdgeInsets.symmetric(horizontal: Space.xs),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card + 6),
        boxShadow: [
          BoxShadow(
            color: ColorManager.ink.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final itemW = box.maxWidth / destinations.length;
          return Stack(
            children: [
              // One indicator that slides between tabs. Selection used to
              // cross-fade two pills (old fading out, new fading in), which
              // left a "trace" of the previous tab after each tap.
              AnimatedPositionedDirectional(
                duration: AppMotion.of(
                  context,
                  const Duration(milliseconds: 240),
                ),
                curve: AppMotion.enter,
                start: currentIndex * itemW + (itemW - _pillW) / 2,
                top: (box.maxHeight - contentH) / 2,
                width: _pillW,
                height: _pillH,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorManager.brandSoft,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    Expanded(
                      child: _NavItem(
                        key: destinations[i].key,
                        destination: destinations[i],
                        selected: i == currentIndex,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? ColorManager.brand : ColorManager.inkFaint;
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      excludeSemantics: true,
      // No ripple or per-item animation: the only motion is the shared
      // sliding pill in [_NavBar]; colours switch instantly.
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: _NavBar._pillH,
              child: Center(
                child: Icon(destination.icon, size: 22, color: color),
              ),
            ),
            SizedBox(height: _NavBar._gap),
            SizedBox(
              height: _NavBar._labelH(context),
              child: Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: selected
                    ? getSemiBoldStyle(
                        fontSize: FontSize.s11,
                        color: ColorManager.brandStrong,
                        height: 1.3,
                      )
                    : getMediumStyle(
                        fontSize: FontSize.s11,
                        color: ColorManager.inkFaint,
                        height: 1.3,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bell extends StatelessWidget {
  const _Bell({super.key, required this.badge, required this.onTap});
  final UnreadBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: badge,
      builder: (context, count, _) {
        return Semantics(
          button: true,
          label: count > 0 ? 'الإشعارات، $count غير مقروءة' : 'الإشعارات',
          excludeSemantics: true,
          child: Material(
            color: ColorManager.surface,
            shape: const CircleBorder(),
            elevation: 0,
            shadowColor: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox.square(
                dimension: AppSizes.touch * 0.92,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      AppIcons.notification,
                      color: ColorManager.ink,
                      size: 22,
                    ),
                    if (count > 0)
                      PositionedDirectional(
                        top: 6,
                        end: 6,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 17,
                            minHeight: 17,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: ColorManager.error,
                            borderRadius: BorderRadius.circular(Radii.chip),
                            border: Border.all(
                              color: ColorManager.surface,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: getNumericStyle(
                              fontSize: 10,
                              color: ColorManager.white,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
