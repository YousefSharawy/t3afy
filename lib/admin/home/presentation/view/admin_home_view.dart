import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/admin_app_bar.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/quick_actions_section.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/send_announcement_sheet.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/stats_grid.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/status_banner.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/today_campaigns_section.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:t3afy/app/local_storage.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  final GlobalKey _statusBannerKey = GlobalKey();
  final GlobalKey _statsGridKey = GlobalKey();
  final GlobalKey _todayCampaignsKey = GlobalKey();
  final GlobalKey _quickActionsKey = GlobalKey();

  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;

  void _showAnnouncementSheet(BuildContext context) {
    final cubit = context.read<AdminHomeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const SendAnnouncementSheet(),
      ),
    );
  }

  Future<void> _confirmExport(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'تصدير تقرير شامل',
      body: 'سيتم إنشاء تقرير شامل بجميع بيانات المنصة. قد يستغرق بضع ثوانٍ.',
      confirmLabel: 'تصدير',
    );
    if (confirmed && context.mounted) {
      context.read<AdminHomeCubit>().exportFullAnalyticsPdf();
    }
  }

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
    if (svc.currentPhase != 1 || !svc.isAdmin) return;
    if (_lastCheckedPhase == 1) return; // Already showed phase 1

    debugPrint('📘 TUTORIAL: AdminHome screen starting phase 1, marking _lastCheckedPhase=1');
    _lastCheckedPhase = 1; // Mark immediately since admin home renders synchronously

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showHomeTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: BlocConsumer<AdminHomeCubit, AdminHomeState>(
        listenWhen: (_, curr) => curr.maybeWhen(
          loaded: (_) => true,
          exportSuccess: () => true,
          exportError: (_) => true,
          orElse: () => false,
        ),
        listener: (context, state) {
          state.maybeWhen(
            loaded: (_) {
              if (_lastCheckedPhase == 0 &&
                  !LocalAppStorage.isAdminTutorialCompleted() &&
                  !TutorialPhaseService.instance.isRunning) {
                TutorialService.showWelcomeOverlay(context, isAdmin: true).then(
                  (start) {
                    if (!mounted) return;
                    if (start == true) {
                      TutorialPhaseService.instance.start(isAdmin: true);
                      _checkTutorial();
                    } else {
                      LocalAppStorage.setAdminTutorialCompleted(true);
                    }
                  },
                );
              }
            },
            exportSuccess: () =>
                Toast.success.show(context, title: 'تم تصدير التقرير بنجاح'),
            exportError: (msg) => Toast.error.show(context, title: msg),
            orElse: () {},
          );
        },
        buildWhen: (prev, curr) => curr.maybeWhen(
          initial: () => true,
          loading: () => true,
          loaded: (_) => true,
          error: (_) => true,
          exportingPdf: () => true,
          exportSuccess: () => true,
          exportError: (_) => true,
          orElse: () => false,
        ),
        builder: (context, state) {
          final isExportingPdf = state.maybeWhen(
            exportingPdf: () => true,
            orElse: () => false,
          );

          return state.maybeWhen(
            loading: () => const LoadingIndicator(),
            error: (message) => ErrorState(
              message: message,
              onRetry: () => context.read<AdminHomeCubit>().loadDashboard(),
            ),
            loaded: (data) => _buildLoaded(
              context,
              data: data,
              isExportingPdf: isExportingPdf,
            ),
            exportingPdf: () =>
                _buildLoaded(context, data: null, isExportingPdf: true),
            exportSuccess: () =>
                _buildLoaded(context, data: null, isExportingPdf: false),
            exportError: (_) =>
                _buildLoaded(context, data: null, isExportingPdf: false),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context, {
    required dynamic data,
    required bool isExportingPdf,
  }) {
    final cubitState = context.read<AdminHomeCubit>().state;
    final loadedData =
        data ?? cubitState.maybeWhen(loaded: (d) => d, orElse: () => null);

    if (loadedData == null) return const LoadingIndicator();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          SizedBox(height: AppHeight.s71),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
            child: AdminAppBar(
              adminName: loadedData.adminName,
              avatarUrl: loadedData.adminAvatar,
            ),
          ),
          SizedBox(height: AppHeight.s16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<AdminHomeCubit>().loadDashboard(),
              color: const Color(0xFF00ABD2),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusBanner(
                        key: _statusBannerKey,
                        activeVolunteersCount: loadedData.activeTodayCount,
                      ),
                      SizedBox(height: AppHeight.s16),
                      StatsGrid(
                        key: _statsGridKey,
                        activeTodayCount: loadedData.activeTodayCount,
                        totalVolunteers: loadedData.totalVolunteers,
                        completedCampaigns: loadedData.completedCampaigns,
                        totalHours: loadedData.totalHours,
                        volunteersThisMonth: loadedData.volunteersThisMonth,
                        activeDiffFromYesterday:
                            loadedData.activeDiffFromYesterday,
                        hoursPercentChange: loadedData.hoursPercentChange,
                      ),
                      SizedBox(height: AppHeight.s16),
                      TodayCampaignsSection(
                        key: _todayCampaignsKey,
                        campaigns: loadedData.todayCampaigns,
                        onViewAll: () => context.go(Routes.campaigns),
                        onCampaignTap: (campaign) async {
                          final cubit = context.read<AdminHomeCubit>();
                          final changed = await context.push<bool>(
                            '/campaignDetails/${campaign.id}',
                          );
                          if (changed == true && context.mounted) {
                            cubit.loadDashboard();
                          }
                        },
                      ),
                      SizedBox(height: AppHeight.s16),
                      QuickActionsSection(
                        key: _quickActionsKey,
                        isExportingPdf: isExportingPdf,
                        onNewCampaign: () async {
                          final cubit = context.read<AdminHomeCubit>();
                          final changed = await context.push<bool>(
                            Routes.createCampaign,
                          );
                          if (changed == true && context.mounted) {
                            cubit.loadDashboard();
                          }
                        },
                        onFullReport: () => _confirmExport(context),
                        onSendAnnouncement: () =>
                            _showAnnouncementSheet(context),
                      ),
                      SizedBox(height: AppHeight.s120),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Phase 1 tutorial
  // ---------------------------------------------------------------------------
  void _showHomeTutorial() {
    final targets = <TargetFocus>[];
    const total = 4;

    if (_statusBannerKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'admin_status_banner',
          keyTarget: _statusBannerKey,
          title: 'حالة النظام',
          description: 'عدد المتطوعين النشطين الآن',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: total,
        ),
      );
    }

    if (_statsGridKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'admin_stats_grid',
          keyTarget: _statsGridKey,
          title: 'إحصائيات المنصة',
          description: 'ملخص شامل: المتطوعين، الحملات المكتملة، ساعات التطوع',
          contentAlign: ContentAlign.bottom,
          stepIndex: 2,
          totalSteps: total,
        ),
      );
    }

    if (_todayCampaignsKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'admin_today_campaigns',
          keyTarget: _todayCampaignsKey,
          title: 'حملات اليوم',
          description: 'الحملات المجدولة لهذا اليوم',
          contentAlign: ContentAlign.top,
          stepIndex: 3,
          totalSteps: total,
        ),
      );
    }

    if (_quickActionsKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'admin_quick_actions',
          keyTarget: _quickActionsKey,
          title: 'إجراءات سريعة',
          description: 'أنشئ حملة جديدة أو أرسل إعلاناً من هنا',
          contentAlign: ContentAlign.top,
          stepIndex: 4,
          totalSteps: total,
        ),
      );
    }

    if (targets.isEmpty) {
      debugPrint(
        '📘 TUTORIAL: AdminHome screen has no targets, advancing to next phase',
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
}
