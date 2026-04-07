import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
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
        debugPrint('📘 TUTORIAL: Performance state is LOADED, marking _lastCheckedPhase=4 and showing tutorial');
        _lastCheckedPhase = 4; // Mark as processed ONLY when state is loaded
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          _showPerformanceTutorial();
        });
      },
      orElse: () {
        debugPrint('📘 TUTORIAL: Performance state still LOADING, will retry when loaded');
        // Don't set _lastCheckedPhase yet - wait for state to load
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<PerformanceCubit, PerformanceState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (_, _, _, _) {
              // GlobalKeys are valid once loaded — trigger tutorial if waiting.
              WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LoadingIndicator(),
            error: (message) => ErrorState(
              message: message,
              onRetry: () {
                final userId = LocalAppStorage.getUserId();
                if (userId != null) {
                  context.read<PerformanceCubit>().loadPerformance(userId);
                }
              },
            ),
            loaded: (stats, monthlyHours, leaderboard, currentUserId) {
              return _buildContent(
                stats,
                monthlyHours,
                leaderboard,
                currentUserId,
              );
            },
          );
        },
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
      debugPrint(
        '📘 TUTORIAL: VolunteerPerformance screen has no targets, advancing to next phase',
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

  Future<void> _refresh() {
    return context.read<PerformanceCubit>().refreshPerformance();
  }

  Widget _buildContent(
    PerformanceStatsEntity stats,
    List<MonthlyHoursEntity> monthlyHours,
    List<LeaderboardEntryEntity> leaderboard,
    String currentUserId,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppHeight.s10),
          child: Text(
            'الاداء و التقييم',
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural900,
              fontSize: FontSize.s16,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: const Color(0xFF00ABD2),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: AppWidth.s18,
                right: AppWidth.s18,
                top: AppHeight.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingCard(key: _ratingCardKey, stats: stats),
                  SizedBox(height: AppHeight.s16),
                  PerformanceStatsRow(stats: stats),
                  SizedBox(height: AppHeight.s12),
                  MonthlyChart(
                    key: _monthlyChartKey,
                    monthlyHours: monthlyHours,
                  ),
                  SizedBox(height: AppHeight.s16),
                  HonorBoard(
                    key: _honorBoardKey,
                    leaderboard: leaderboard,
                    currentUserId: currentUserId,
                  ),
                  SizedBox(height: AppHeight.s100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
