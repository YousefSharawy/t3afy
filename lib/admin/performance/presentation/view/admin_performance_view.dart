import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
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

    debugPrint('📘 TUTORIAL: AdminPerformance screen starting phase 5, marking _lastCheckedPhase=5');
    _lastCheckedPhase = 5; // Mark immediately since admin performance renders synchronously
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _showPerformanceTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'التقارير والاحصاء',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.natural900,
            ),
          ),
        ),
        body: BlocConsumer<AdminPerformanceCubit, AdminPerformanceState>(
          listener: (context, state) {
            if (state is AdminPerformanceLoaded) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _checkTutorial(),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminPerformanceInitial) {
              return const LoadingIndicator();
            }
            if (state is AdminPerformanceError) {
              return ErrorState(
                message: state.message,
                onRetry: () => context
                    .read<AdminPerformanceCubit>()
                    .loadPerformance(state.selectedPeriod, forceRefresh: true),
              );
            }

            final isLoading = state is AdminPerformanceLoading;
            final data = state is AdminPerformanceLoaded ? state.data : null;

            return Stack(
              children: [
                if (data != null)
                  RefreshIndicator(
                    onRefresh: () =>
                        context.read<AdminPerformanceCubit>().loadPerformance(
                          (state as AdminPerformanceLoaded).selectedPeriod,
                          forceRefresh: true,
                        ),
                    color: ColorManager.primary500,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppHeight.s24),
                          const PerformanceTimeFilter(),
                          SizedBox(height: AppHeight.s16),
                          PerformanceStatsRow(key: _statsRowKey, data: data),
                          SizedBox(height: AppHeight.s8),
                          PerformanceBarChart(
                            bars: data.chartBars,
                            title: switch (state is AdminPerformanceLoaded
                                ? state.selectedPeriod
                                : 'year') {
                              'week' => 'المهام المنجزة أسبوعياً',
                              'months' => 'المهام المنجزة شهرياً',
                              _ => 'المهام المنجزة سنوياً',
                            },
                          ),
                          SizedBox(height: AppHeight.s8),
                          RegionRankingSection(regions: data.topRegions),
                          SizedBox(height: AppHeight.s8),
                          CampaignCompletionCard(
                            data: data,
                            selectedPeriod: state is AdminPerformanceLoaded
                                ? state.selectedPeriod
                                : 'year',
                          ),
                          SizedBox(height: AppHeight.s120),
                        ],
                      ),
                    ),
                  )
                else
                  const LoadingIndicator(),
                if (isLoading && data != null)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: Colors.white54,
                        child: LoadingIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
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
      debugPrint(
        '📘 TUTORIAL: AdminPerformance screen has no targets, completing tutorial',
      );
      _finishPhase5(shell);
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
      onFinish: () => _finishPhase5(shell),
      onSkip: () {
        _finishPhase5(shell); // Finish tutorial since it's the last phase
        return true;
      },
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
