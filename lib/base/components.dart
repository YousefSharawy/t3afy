import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/nav_bar_item.dart';
import 'package:t3afy/translation/locale_keys.g.dart';
import 'package:t3afy/app/services/tutorial_service.dart';

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
  // BannerAd? _bannerAd;
  // bool _isLoadingAd = false;
  // String? _adLoadError;

  void _loadAd() async {
    // if (_isLoadingAd) return;

    // _isLoadingAd = true;
    // setState(() {});

    // try {
    //   final size =
    //       await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //         MediaQuery.sizeOf(context).width.truncate(),
    //       );

    //   if (size == null) {
    //     debugPrint("Unable to get width of anchored banner.");
    //     _isLoadingAd = false;
    //     setState(() {});
    //     return;
    //   }

    //   final ad = BannerAd(
    //     adUnitId: AppAdsHelper.bannerAdUnitId,
    //     request: const AdRequest(),
    //     size: size,
    //     listener: BannerAdListener(
    //       onAdLoaded: (ad) {
    //         debugPrint("Banner ad loaded successfully.");
    //         _isLoadingAd = false;
    //         _adLoadError = null;
    //         setState(() {
    //           _bannerAd = ad as BannerAd;
    //         });
    //       },
    //       onAdFailedToLoad: (ad, error) {
    //         debugPrint("Banner ad failed to load: $error");
    //         _isLoadingAd = false;
    //         _adLoadError = error.message;
    //         ad.dispose();
    //         setState(() {});
    //       },
    //       onAdImpression: (ad) {
    //         debugPrint("Banner ad impression recorded.");
    //       },
    //     ),
    //   );

    //   await ad.load();
    // } catch (e) {
    //   debugPrint("Error loading banner ad: $e");
    //   _isLoadingAd = false;
    //   _adLoadError = e.toString();
    //   setState(() {});
    // }
  }

  @override
  void initState() {
    super.initState();
    if (widget.showBannerAd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAd();
      });
    }
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      backgroundColor: widget.backgroundColor ?? ColorManager.background,
      body: widget.body,
      bottomNavigationBar: _buildBottomAdContainer(),
    );
  }

  Widget _buildBottomAdContainer() {
    // if (_isLoadingAd) {
    //   return Container(
    //     height: AdSize.banner.height.toDouble(),
    //     color: Colors.transparent,
    //     child: const Center(
    //       child: SizedBox(
    //         width: 20,
    //         height: 20,
    //         child: CircularProgressIndicator(strokeWidth: 2),
    //       ),
    //     ),
    //   );
    // }

    // if (_bannerAd != null) {
    //   return Container(
    //     height: _bannerAd!.size.height.toDouble(),
    //     width: double.infinity,
    //     alignment: Alignment.center,
    //     child: AdWidget(ad: _bannerAd!),
    //   );
    // }

    // if (_adLoadError != null) {
    //   return Container(
    //     height: AdSize.banner.height.toDouble(),
    //     color: Colors.transparent,
    //     child: Center(
    //       child: Text(
    //         'Ad failed to load',
    //         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    //       ),
    //     ),
    //   );
    // }

    return const SizedBox.shrink();
  }
}

class VolunteerScaffoldWithNavBar extends StatefulWidget {
  const VolunteerScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  State<VolunteerScaffoldWithNavBar> createState() =>
      _VolunteerScaffoldWithNavBarState();
}

class _VolunteerScaffoldWithNavBarState
    extends State<VolunteerScaffoldWithNavBar> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();

    // Register tab switcher for tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TutorialPhaseService.instance.registerSwitchTab(
          (index) => widget.navigationShell.goBranch(index, initialLocation: false),
        );
      }
    });
  }

  Future<void> _loadUnreadCount() async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;
    try {
      final res = await Supabase.instance.client
          .from('admin_notes')
          .select('id')
          .eq('volunteer_id', userId)
          .eq('is_read', false);
      if (mounted) setState(() => _unreadCount = (res as List).length);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Stack(
        children: [
          Positioned.fill(child: widget.navigationShell),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppHeight.s5,
            left: AppWidth.s18,
            child: _buildNotificationButton(context),
          ),
          Positioned(
            left: AppWidth.s18,
            right: AppWidth.s18,
            bottom: AppHeight.s34,
            child: _buildNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push(Routes.notifications).then((_) => _loadUnreadCount()),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(AppRadius.s10),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Image.asset(
              IconAssets.notification,
              width: AppWidth.s24,
              height: AppHeight.s24,
            ),
          ),
          if (_unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 14.sp, minHeight: 14.sp),
                child: Text(
                  '$_unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s49),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 0),
            blurRadius: 9,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppHeight.s10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              key: AppTutorialKeys.volunteerHomeTabKey,
              iconPath: IconAssets.home,
              label: LocaleKeys.home.tr(),
              isSelected: widget.navigationShell.currentIndex == 0,
              onTap: () => _onTap(context, 0),
            ),
            NavBarItem(
              key: AppTutorialKeys.volunteerTasksTabKey,
              iconPath: IconAssets.tasks,
              label: LocaleKeys.tasks.tr(),
              isSelected: widget.navigationShell.currentIndex == 1,
              onTap: () => _onTap(context, 1),
            ),
            NavBarItem(
              key: AppTutorialKeys.volunteerMapTabKey,
              iconPath: IconAssets.map,
              label: LocaleKeys.map.tr(),
              isSelected: widget.navigationShell.currentIndex == 2,
              onTap: () => _onTap(context, 2),
            ),
            NavBarItem(
              key: AppTutorialKeys.volunteerPerformanceTabKey,
              iconPath: IconAssets.performance,
              label: LocaleKeys.performance.tr(),
              isSelected: widget.navigationShell.currentIndex == 3,
              onTap: () => _onTap(context, 3),
            ),
            NavBarItem(
              key: AppTutorialKeys.volunteerBotTabKey,
              iconPath: IconAssets.bot,
              label: LocaleKeys.bot.tr(),
              isSelected: widget.navigationShell.currentIndex == 4,
              onTap: () => _onTap(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == widget.navigationShell.currentIndex) return;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class AdminScaffoldWithNavBar extends StatefulWidget {
  const AdminScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  State<AdminScaffoldWithNavBar> createState() =>
      _AdminScaffoldWithNavBarState();
}

class _AdminScaffoldWithNavBarState extends State<AdminScaffoldWithNavBar> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();

    // Register tab switcher for tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TutorialPhaseService.instance.registerSwitchTab(
          (index) => widget.navigationShell.goBranch(index, initialLocation: false),
        );
      }
    });
  }

  Future<void> _loadUnreadCount() async {
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) return;
    try {
      final res = await Supabase.instance.client
          .from('admin_notes')
          .select('id')
          .eq('admin_id', adminId)
          .eq('volunteer_id', adminId)
          .eq('is_read', false);
      if (mounted) setState(() => _unreadCount = (res as List).length);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Stack(
        children: [
          Positioned.fill(child: widget.navigationShell),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppHeight.s5,
            left: AppWidth.s18,
            child: _buildNotificationButton(context),
          ),
          Positioned(
            left: AppWidth.s18,
            right: AppWidth.s18,
            bottom: AppHeight.s34,
            child: _buildNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      key: AppTutorialKeys.adminNotificationKey,
      onTap: () => context
          .push(Routes.adminNotifications)
          .then((_) => _loadUnreadCount()),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(AppRadius.s10),
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Image.asset(
              IconAssets.notification,
              width: AppWidth.s24,
              height: AppHeight.s24,
            ),
          ),
          if (_unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 14.sp, minHeight: 14.sp),
                child: Text(
                  '$_unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s49),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 0),
            blurRadius: 9,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppHeight.s10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              key: AppTutorialKeys.adminHomeTabKey,
              iconPath: IconAssets.home,
              label: "الرئيسية",
              isSelected: widget.navigationShell.currentIndex == 0,
              onTap: () => _onTap(context, 0),
            ),
            NavBarItem(
              key: AppTutorialKeys.adminVolunteersTabKey,
              iconPath: IconAssets.group,
              label: "المتطوعين",
              isSelected: widget.navigationShell.currentIndex == 1,
              onTap: () => _onTap(context, 1),
            ),
            NavBarItem(
              key: AppTutorialKeys.adminCampaignsTabKey,
              iconPath: IconAssets.campaigns,
              label: "الحملات",
              isSelected: widget.navigationShell.currentIndex == 2,
              onTap: () => _onTap(context, 2),
            ),
            NavBarItem(
              key: AppTutorialKeys.adminReportsTabKey,
              iconPath: IconAssets.reports,
              label: "التقارير",
              isSelected: widget.navigationShell.currentIndex == 3,
              onTap: () => _onTap(context, 3),
            ),
            NavBarItem(
              key: AppTutorialKeys.adminPerformanceTabKey,
              iconPath: IconAssets.performance,
              label: "الاحصاء",
              isSelected: widget.navigationShell.currentIndex == 4,
              onTap: () => _onTap(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == widget.navigationShell.currentIndex) return;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
