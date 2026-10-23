import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/volunteer/performance/presentation/cubit/performance_cubit.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/honor_board.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/monthly_chart.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/performance_stats_row.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/rating_card.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VolunteerPerformanceView extends StatefulWidget {
  const VolunteerPerformanceView({super.key});

  @override
  State<VolunteerPerformanceView> createState() =>
      _VolunteerPerformanceViewState();
}

class _VolunteerPerformanceViewState extends State<VolunteerPerformanceView> {
  final GlobalKey _ratingCardKey = GlobalKey();
  final GlobalKey _monthlyChartKey = GlobalKey();
  final GlobalKey _honorBoardKey = GlobalKey();

  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PerformanceCubit>();
    if (!cubit.state.maybeWhen(
      loaded: (a, b, c, d) => true,
      orElse: () => false,
    )) {
      final userId = LocalAppStorage.getUserId();
      if (userId != null) {
        cubit.loadPerformance(userId);
      }
    }

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
    if (svc.currentPhase != 4 || svc.isAdmin) return;
    if (_lastCheckedPhase == 4) return; // Already showed phase 4

    final cubit = context.read<PerformanceCubit>();
    final state = cubit.state;

    state.maybeWhen(
      loaded: (_, _, _, _) {
        _lastCheckedPhase = 4; // Mark as processed ONLY when state is loaded
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          _showPerformanceTutorial();
        });
      },
      orElse: () {
        // Don't set _lastCheckedPhase yet - wait for state to load
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppPageHeader(title: 'الأداء والتقييم', reserveBellSpace: true),
          Expanded(
            child: BlocConsumer<PerformanceCubit, PerformanceState>(
              listener: (context, state) {
                state.maybeWhen(
                  loaded: (_, _, _, _) {
                    // GlobalKeys are valid once loaded — trigger tutorial if waiting.
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _checkTutorial(),
                    );
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return state.when(
                  initial: () => const _PerformanceSkeleton(),
                  loading: () => const _PerformanceSkeleton(),
                  error: (message) => ErrorState(
                    message: message,
                    onRetry: () {
                      final userId = LocalAppStorage.getUserId();
                      if (userId != null) {
                        context.read<PerformanceCubit>().loadPerformance(
                          userId,
                        );
                      }
                    },
                  ),
                  loaded: (stats, monthlyHours, leaderboard, currentUserId) =>
                      _buildContent(
                        stats,
                        monthlyHours,
                        leaderboard,
                        currentUserId,
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPerformanceTutorial() {
    final targets = <TargetFocus>[];
    const total = 3;

    if (_ratingCardKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'perf_rating',
          keyTarget: _ratingCardKey,
          title: 'تقييمك',
          description: 'تقييمك الكلي من المشرفين',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: total,
        ),
      );
    }

    if (_monthlyChartKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'perf_chart',
          keyTarget: _monthlyChartKey,
          title: 'الأداء الشهري',
          description: 'تابع تطور ساعاتك وأدائك شهرياً',
          contentAlign: ContentAlign.top,
          stepIndex: 2,
          totalSteps: total,
        ),
      );
    }

    if (_honorBoardKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'perf_honor_board',
          keyTarget: _honorBoardKey,
          title: 'لوحة الشرف',
          description: 'ترتيبك بين المتطوعين — نافس على المركز الأول!',
          contentAlign: ContentAlign.top,
          stepIndex: 3,
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
      onFinish: () => TutorialPhaseService.instance.advanceToNextPhase(),
    ).show(context: context, rootOverlay: true);
  }

  Future<void> _refresh() async {
    final error = await context.read<PerformanceCubit>().refreshPerformance();
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  Widget _buildContent(
    PerformanceStatsEntity stats,
    List<MonthlyHoursEntity> monthlyHours,
    List<LeaderboardEntryEntity> leaderboard,
    String currentUserId,
  ) {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorManager.brand,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: Space.gutter,
          end: Space.gutter,
          top: Space.vs,
          bottom: AppNavShell.bottomInset(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RatingCard(key: _ratingCardKey, stats: stats),
            SizedBox(height: Space.vm),
            PerformanceStatsRow(stats: stats),
            SizedBox(height: Space.vxl),
            MonthlyChart(key: _monthlyChartKey, monthlyHours: monthlyHours),
            SizedBox(height: Space.vxl),
            HonorBoard(
              key: _honorBoardKey,
              leaderboard: leaderboard,
              currentUserId: currentUserId,
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceSkeleton extends StatelessWidget {
  const _PerformanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: Space.gutter,
          vertical: Space.vs,
        ),
        children: [
          SkeletonBox(height: 150.h, radius: Radii.card),
          SizedBox(height: Space.vm),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) SizedBox(width: Space.s),
                Expanded(
                  child: SkeletonBox(height: 96.h, radius: Radii.card),
                ),
              ],
            ],
          ),
          SizedBox(height: Space.vxl),
          SkeletonBox(height: 220.h, radius: Radii.card),
          SizedBox(height: Space.vxl),
          for (var i = 0; i < 3; i++) ...[
            SkeletonBox(height: 64.h, radius: Radii.card),
            SizedBox(height: Space.vs),
          ],
        ],
      ),
    );
  }
}
