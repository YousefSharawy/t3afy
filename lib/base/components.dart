import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/cubit/navigation_cubit.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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

class VolunteerScaffoldWithNavBar extends StatelessWidget {
  const VolunteerScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: navigationShell)]),
      extendBody: false,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: AppWidth.s18,
          right: AppWidth.s18,
          bottom: AppHeight.s34,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.s49),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2.sp,
            colors: [ColorManager.blueOne800, ColorManager.blueOne900],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppHeight.s10),
          child: Row(
            // spacing: 10.sp,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                iconPath: IconAssets.home,
                label: LocaleKeys.home.tr(),
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _onTap(context, 0),
              ),
              _NavBarItem(
                iconPath: IconAssets.tasks,
                label: LocaleKeys.tasks.tr(),
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _onTap(context, 1),
              ),
              _NavBarItem(
                iconPath: IconAssets.map,
                label: LocaleKeys.map.tr(),
                isSelected: navigationShell.currentIndex == 2,
                onTap: () => _onTap(context, 2),
              ),
              _NavBarItem(
                iconPath: IconAssets.performance,
                label: LocaleKeys.performance.tr(),
                isSelected: navigationShell.currentIndex == 3,
                onTap: () async {
                  _onTap(context, 3);
                },
              ),
              _NavBarItem(
                iconPath: IconAssets.bot,
                label: LocaleKeys.bot.tr(),
                isSelected: navigationShell.currentIndex == 4,
                onTap: () async {
                  _onTap(context, 4);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == navigationShell.currentIndex) return;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant _NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Image.asset(
                  widget.iconPath,
                  width: AppWidth.s24,
                  height: AppHeight.s24,
                ),
              ),
              SizedBox(height: AppHeight.s4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s10,
                  color: widget.isSelected
                      ? ColorManager.blueThree500
                      : ColorManager.white,
                ),
                child: Text(widget.label),
              ),
              SizedBox(height: 3.sp),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: widget.isSelected ? AppWidth.s24 : 0,
                height: AppHeight.s2,
                decoration: BoxDecoration(
                  color: ColorManager.blueThree500,
                  borderRadius: BorderRadius.circular(AppRadius.s1),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
