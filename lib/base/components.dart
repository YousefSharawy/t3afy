import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/translation/locale_keys.g.dart';

class PrimaryScaffold extends StatefulWidget {
  const PrimaryScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showBannerAd = false,
    this.drawer,
    this.backgroundColor,
  });
  final Widget body;
  final AppBar? appBar;
  final bool showBannerAd;
  final Drawer? drawer;
  final Color? backgroundColor;
  @override
  State<PrimaryScaffold> createState() => _PrimaryScaffoldState();
}

class _PrimaryScaffoldState extends State<PrimaryScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      backgroundColor: widget.backgroundColor ?? ColorManager.background,
      body: widget.body,
    );
  }
}

/// Volunteer bottom-nav shell (5 tabs).
class VolunteerScaffoldWithNavBar extends StatelessWidget {
  const VolunteerScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppNavShell(
      navigationShell: navigationShell,
      isAdmin: false,
      notificationsRoute: Routes.notifications,
      bellKey: AppTutorialKeys.volunteerNotificationKey,
      destinations: [
        NavDestination(
          key: AppTutorialKeys.volunteerHomeTabKey,
          icon: AppIcons.home,
          label: LocaleKeys.home.tr(),
        ),
        NavDestination(
          key: AppTutorialKeys.volunteerTasksTabKey,
          icon: AppIcons.tasks,
          label: LocaleKeys.tasks.tr(),
        ),
        NavDestination(
          key: AppTutorialKeys.volunteerMapTabKey,
          icon: AppIcons.map,
          label: LocaleKeys.map.tr(),
        ),
        NavDestination(
          key: AppTutorialKeys.volunteerPerformanceTabKey,
          icon: AppIcons.performance,
          label: LocaleKeys.performance.tr(),
        ),
        NavDestination(
          key: AppTutorialKeys.volunteerBotTabKey,
          icon: AppIcons.bot,
          label: LocaleKeys.bot.tr(),
        ),
      ],
    );
  }
}

/// Manager (مشرف) bottom-nav shell (5 tabs).
class AdminScaffoldWithNavBar extends StatelessWidget {
  const AdminScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AppNavShell(
      navigationShell: navigationShell,
      isAdmin: true,
      notificationsRoute: Routes.adminNotifications,
      bellKey: AppTutorialKeys.adminNotificationKey,
      destinations: [
        NavDestination(
          key: AppTutorialKeys.adminHomeTabKey,
          icon: AppIcons.home,
          label: 'الرئيسية',
        ),
        NavDestination(
          key: AppTutorialKeys.adminVolunteersTabKey,
          icon: AppIcons.group,
          label: 'المتطوعين',
        ),
        NavDestination(
          key: AppTutorialKeys.adminCampaignsTabKey,
          icon: AppIcons.campaigns,
          label: 'الحملات',
        ),
        NavDestination(
          key: AppTutorialKeys.adminReportsTabKey,
          icon: AppIcons.reports,
          label: 'المراجعة',
        ),
        NavDestination(
          key: AppTutorialKeys.adminPerformanceTabKey,
          icon: AppIcons.performance,
          label: 'الإحصاء',
        ),
      ],
    );
  }
}
