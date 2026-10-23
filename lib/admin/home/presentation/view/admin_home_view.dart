import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/admin_app_bar.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/quick_actions_section.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/send_announcement_sheet.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/stats_grid.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/status_banner.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/today_campaigns_section.dart';
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
  bool _welcomeShown = false;

  /// TickerMode is off when this tab is not the active shell branch or a
  /// pushed screen covers it; the cubit pauses its 60 s refresh meanwhile.
  ValueListenable<TickerModeData>? _tickerMode;

  void _onTickerModeChanged() {
    final notifier = _tickerMode;
    if (notifier == null || !mounted) return;
    context.read<AdminHomeCubit>().setVisible(notifier.value.enabled);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = TickerMode.getValuesNotifier(context);
    if (notifier != _tickerMode) {
      _tickerMode?.removeListener(_onTickerModeChanged);
      _tickerMode = notifier..addListener(_onTickerModeChanged);
      _onTickerModeChanged();
    }
  }

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

  Future<void> _newCampaign(BuildContext context) async {
    final cubit = context.read<AdminHomeCubit>();
    final changed = await context.push<bool>(Routes.createCampaign);
    if (changed == true && context.mounted) cubit.refresh();
  }

  Future<void> _refresh(BuildContext context) async {
    final error = await context.read<AdminHomeCubit>().refresh();
    if (error != null && context.mounted) {
      Toast.error.show(context, title: error);
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
    _tickerMode?.removeListener(_onTickerModeChanged);
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
    _lastCheckedPhase = 1;

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showHomeTutorial();
    });
  }

  void _maybeShowWelcome(BuildContext context) {
    if (_welcomeShown ||
        _lastCheckedPhase != 0 ||
        LocalAppStorage.isAdminTutorialCompleted() ||
        TutorialPhaseService.instance.isRunning) {
      return;
    }
    _welcomeShown = true;
    TutorialService.showWelcomeOverlay(context, isAdmin: true).then((start) {
      if (!mounted) return;
      if (start == true) {
        TutorialPhaseService.instance.start(isAdmin: true);
        _checkTutorial();
      } else {
        LocalAppStorage.setAdminTutorialCompleted(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Light status-bar icons over the Deep Root command band.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ColoredBox(
      color: ColorManager.canvas,
      child: BlocConsumer<AdminHomeCubit, AdminHomeState>(
        listenWhen: (_, curr) => curr.maybeWhen(
          loaded: (_) => true,
          exportSuccess: () => true,
          exportError: (_) => true,
          orElse: () => false,
        ),
        listener: (context, state) {
          state.maybeWhen(
            loaded: (_) => _maybeShowWelcome(context),
            exportSuccess: () =>
                Toast.success.show(context, title: 'تم تصدير التقرير بنجاح'),
            exportError: (msg) => Toast.error.show(context, title: msg),
            orElse: () {},
          );
        },
        // Announcement states belong to the sheet; never rebuild the
        // dashboard for them.
        buildWhen: (_, curr) => curr.maybeWhen(
          announcementSending: () => false,
          announcementSent: () => false,
          announcementError: (_) => false,
          orElse: () => true,
        ),
        builder: (context, state) {
          final cubit = context.read<AdminHomeCubit>();
          final data = cubit.data;
          final Widget child;
          if (data != null) {
            child = _buildLoaded(
              context,
              data: data,
              lastUpdated: cubit.lastUpdated,
              isExportingPdf: state.maybeWhen(
                exportingPdf: () => true,
                orElse: () => false,
              ),
            );
          } else {
            child = state.maybeWhen(
              error: (message) => SafeArea(
                child: ErrorState(
                  message: message,
                  onRetry: cubit.loadDashboard,
                ),
              ),
              orElse: () => const _HomeSkeleton(),
            );
          }
          return AnimatedSwitcher(
            duration: AppMotion.of(context),
            child: KeyedSubtree(
              key: ValueKey(data != null ? 'data' : 'empty'),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context, {
    required AdminHomeDataEntity data,
    required DateTime? lastUpdated,
    required bool isExportingPdf,
  }) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      color: ColorManager.brand,
      edgeOffset: MediaQuery.paddingOf(context).top,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: AppNavShell.bottomInset(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommandBand(
              children: [
                AdminAppBar(
                  adminName: data.adminName,
                  avatarUrl: data.adminAvatar,
                ),
                SizedBox(height: Space.vl),
                StatusBanner(
                  key: _statusBannerKey,
                  activeVolunteersCount: data.activeTodayCount,
                  lastUpdated: lastUpdated,
                ),
                SizedBox(height: Space.vl),
                StatsGrid(
                  key: _statsGridKey,
                  activeTodayCount: data.activeTodayCount,
                  totalVolunteers: data.totalVolunteers,
                  completedCampaigns: data.completedCampaigns,
                  totalHours: data.totalHours,
                  volunteersThisMonth: data.volunteersThisMonth,
                  activeDiffFromYesterday: data.activeDiffFromYesterday,
                  hoursPercentChange: data.hoursPercentChange,
                ),
              ],
            ),
            SizedBox(height: Space.vxl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Space.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TodayCampaignsSection(
                    key: _todayCampaignsKey,
                    campaigns: data.todayCampaigns,
                    onViewAll: () => context.go(Routes.campaigns),
                    onNewCampaign: () => _newCampaign(context),
                    onCampaignTap: (campaign) async {
                      final cubit = context.read<AdminHomeCubit>();
                      final changed = await context.push<bool>(
                        '/campaignDetails/${campaign.id}',
                      );
                      if (changed == true && context.mounted) cubit.refresh();
                    },
                  ),
                  SizedBox(height: Space.vl),
                  QuickActionsSection(
                    key: _quickActionsKey,
                    isExportingPdf: isExportingPdf,
                    onNewCampaign: () => _newCampaign(context),
                    onFullReport: () => _confirmExport(context),
                    onSendAnnouncement: () => _showAnnouncementSheet(context),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    TutorialService.buildPhaseContinuing(
      targets: targets,
      onFinish: TutorialPhaseService.instance.advanceToNextPhase,
    ).show(context: context, rootOverlay: true);
  }
}

/// Deep Root band at the top of the Manager home (behind the status bar).
class _CommandBand extends StatelessWidget {
  const _CommandBand({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        Space.gutter,
        MediaQuery.paddingOf(context).top + Space.vs,
        Space.gutter,
        Space.vxl,
      ),
      decoration: BoxDecoration(
        color: ColorManager.ink,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(Radii.sheet),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// First-load placeholder shaped like the dashboard.
class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget tile() => Container(
      height: 104,
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Radii.card),
      ),
    );
    Widget tileRow() => Row(
      children: [
        Expanded(child: tile()),
        SizedBox(width: Space.m),
        Expanded(child: tile()),
      ],
    );
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommandBand(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorManager.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Space.vl),
              Container(
                width: 180,
                height: 14,
                decoration: BoxDecoration(
                  color: ColorManager.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Radii.small),
                ),
              ),
              SizedBox(height: Space.vxl),
              tileRow(),
              SizedBox(height: Space.vm),
              tileRow(),
            ],
          ),
          SkeletonList(
            count: 2,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: Space.gutter,
              vertical: Space.vxl,
            ),
          ),
        ],
      ),
    );
  }
}
