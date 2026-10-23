import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_cubit.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/campaign_completion_card.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/performance_bar_chart.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/performance_stats_row.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/performance_time_filter.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/region_ranking_section.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AdminPerformanceView extends StatefulWidget {
  const AdminPerformanceView({super.key});

  @override
  State<AdminPerformanceView> createState() => _AdminPerformanceViewState();
}

class _AdminPerformanceViewState extends State<AdminPerformanceView> {
  final GlobalKey _statsRowKey = GlobalKey();

  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;

  @override
  void initState() {
    super.initState();
    _tutorialListener = () => _checkTutorial();
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);
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
    if (svc.currentPhase != 5 || !svc.isAdmin) return;
    if (_lastCheckedPhase == 5) return; // Already showed phase 5

    _lastCheckedPhase = 5; // Mark immediately since admin performance renders synchronously
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _showPerformanceTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // go_router's StatefulShellRoute disables tickers on hidden branches, so
    // TickerMode tells us whether this tab is the one on screen.
    context.read<AdminPerformanceCubit>().setVisible(TickerMode.valuesOf(context).enabled);
  }

  Future<void> _refresh(BuildContext context) async {
    final error = await context.read<AdminPerformanceCubit>().refresh();
    if (error != null && context.mounted) {
      Toast.error.show(context, title: error);
    }
  }

  static String _chartTitle(String period) => switch (period) {
    'week' => 'المهام المنجزة يوميًا',
    'months' => 'المهام المنجزة أسبوعيًا',
    _ => 'المهام المنجزة شهريًا',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'الإحصاء', reserveBellSpace: true),
            Expanded(
              child: BlocConsumer<AdminPerformanceCubit, AdminPerformanceState>(
                listenWhen: (prev, curr) =>
                    curr is AdminPerformanceLoaded &&
                    prev is! AdminPerformanceLoaded,
                listener: (context, state) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _checkTutorial(),
                  );
                },
                builder: (context, state) {
                  final loaded = state is AdminPerformanceLoaded ? state : null;
                  return AppAsyncBody(
                    hasData: loaded != null,
                    isRefreshing: loaded?.isRefreshing ?? false,
                    errorMessage: state is AdminPerformanceError
                        ? state.message
                        : null,
                    onRetry: () => context
                        .read<AdminPerformanceCubit>()
                        .loadPerformance(
                          context.read<AdminPerformanceCubit>().currentPeriod,
                          forceRefresh: true,
                        ),
                    skeleton: const _PerformanceSkeleton(),
                    builder: (context) => _buildLoaded(context, loaded!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, AdminPerformanceLoaded state) {
    final data = state.data;
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      color: ColorManager.brand,
      backgroundColor: ColorManager.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(
          Space.gutter,
          Space.vxs,
          Space.gutter,
          AppNavShell.bottomInset(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PerformanceTimeFilter(),
            SizedBox(height: Space.vl),
            PerformanceStatsRow(key: _statsRowKey, data: data),
            SizedBox(height: Space.vl),
            PerformanceBarChart(
              bars: data.chartBars,
              title: _chartTitle(state.selectedPeriod),
            ),
            SizedBox(height: Space.vl),
            RegionRankingSection(regions: data.topRegions),
            SizedBox(height: Space.vl),
            CampaignCompletionCard(
              data: data,
              selectedPeriod: state.selectedPeriod,
            ),
          ],
        ),
      ),
    );
  }

  void _showPerformanceTutorial() {
    final shell = StatefulNavigationShell.of(context);
    final targets = <TargetFocus>[];

    if (_statsRowKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'admin_perf_stats',
          keyTarget: _statsRowKey,
          title: 'تحليل الأداء',
          description: 'تابع أداء المتطوعين وتوزيعهم حسب المنطقة',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: 1,
        ),
      );
    }

    if (targets.isEmpty) {
      _finishPhase5(shell);
      return;
    }

    TutorialService.buildPhaseContinuing(
      targets: targets,
      onFinish: () => _finishPhase5(shell),
      // Last phase: skipping finishes the tutorial.
      onSkip: () => _finishPhase5(shell),
    ).show(context: context, rootOverlay: true);
  }

  void _finishPhase5(StatefulNavigationShellState shell) {
    TutorialPhaseService.instance.complete();
    LocalAppStorage.setAdminTutorialCompleted(true);
    shell.goBranch(0);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        TutorialService.showCompletionOverlay(
          context,
          isAdmin: true,
          onDone: () {},
        );
      }
    });
  }
}

class _PerformanceSkeleton extends StatelessWidget {
  const _PerformanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Space.gutter,
        vertical: Space.vxs,
      ),
      children: [
        Skeleton(child: SkeletonBox(height: 44, radius: Radii.input)),
        SizedBox(height: Space.vl),
        const SkeletonStats(count: 4, columns: 2),
        SizedBox(height: Space.vl),
        const SkeletonCard(height: 220),
        SizedBox(height: Space.vl),
        const SkeletonCard(height: 160),
      ],
    );
  }
}
