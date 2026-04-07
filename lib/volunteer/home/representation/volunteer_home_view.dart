import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/home/representation/cubit/home_cubit.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/greeting_card.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/home_app_bar.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/stats_grid.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/todays_task_section.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VolunteerHomeView extends StatefulWidget {
  const VolunteerHomeView({super.key});

  @override
  State<VolunteerHomeView> createState() => _VolunteerHomeViewState();
}

class _VolunteerHomeViewState extends State<VolunteerHomeView> {
  final GlobalKey _greetingKey = GlobalKey();
  final GlobalKey _statsGridKey = GlobalKey();
  final GlobalKey _todayTasksKey = GlobalKey();

  late final VoidCallback _tutorialListener;
  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      LocalAppStorage.clearUserSession();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(Routes.login);
      });
      return;
    }
    context.read<HomeCubit>()
      ..subscribeToUserUpdates(userId)
      ..loadHome(userId);

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
    if (_tutorialShown) return;
    if (!TutorialPhaseService.instance.isRunning) return;
    if (TutorialPhaseService.instance.currentPhase != 1 ||
        TutorialPhaseService.instance.isAdmin) {
      return;
    }

    _tutorialShown = true;
    debugPrint('📘 TUTORIAL: Home screen starting phase 1');

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _showHomeTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (s, t, u) {
            // First-time flow: show welcome dialog then start tutorial.
            if (!_tutorialShown &&
                !LocalAppStorage.isVolunteerTutorialCompleted() &&
                !TutorialPhaseService.instance.isRunning) {
              TutorialService.showWelcomeOverlay(context, isAdmin: false).then((
                start,
              ) {
                if (!mounted) return;
                if (start == true) {
                  TutorialPhaseService.instance.start(isAdmin: false);
                  _checkTutorial();
                } else {
                  LocalAppStorage.setVolunteerTutorialCompleted(true);
                }
              });
            }
            // Restart path: tutorial already running at phase 1 — data just
            // loaded so GlobalKeys are now valid.
            _checkTutorial();
          },
          error: (message) {
            if (message == '__suspended__') {
              LocalAppStorage.clearUserSession();
              context.go(Routes.login);
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const LoadingIndicator(),
          error: (message) {
            if (message == '__suspended__') return const SizedBox.shrink();
            return ErrorState(
              message: message,
              onRetry: () {
                final userId = LocalAppStorage.getUserId();
                if (userId != null) {
                  context.read<HomeCubit>().loadHome(userId);
                }
              },
            );
          },
          loaded: (stats, todayTasks, unreadCount) => Column(
            children: [
              SizedBox(height: AppHeight.s45),
              Padding(
                padding: EdgeInsets.only(
                  left: AppWidth.s18,
                  right: AppWidth.s18,
                  top: AppHeight.s10,
                  bottom: AppHeight.s10,
                ),
                child: HomeAppBar(
                  onProfileTap: () => context.push(Routes.volunteerProfile),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final userId = LocalAppStorage.getUserId();
                    if (userId != null) {
                      await context.read<HomeCubit>().loadHome(userId);
                    }
                  },
                  color: ColorManager.blueOne400,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: AppWidth.s18,
                      right: AppWidth.s18,
                      top: AppHeight.s24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreetingCard(
                          key: _greetingKey,
                          name: stats.name,
                          level: stats.level,
                          levelTitle: stats.levelTitle,
                        ),
                        SizedBox(height: AppHeight.s16),
                        Text(
                          'احصائياتي',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.natural900,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        SizedBox(height: AppHeight.s8),
                        StatsGrid(
                          key: _statsGridKey,
                          placesVisited: stats.placesVisited,
                          totalHours: stats.totalHours,
                          rating: stats.rating,
                          totalTasks: stats.totalTasks,
                          totalPoints: stats.totalPoints,
                        ),
                        SizedBox(height: AppHeight.s8),
                        TodayTasksSection(
                          key: _todayTasksKey,
                          tasks: todayTasks,
                          onViewAll: () {
                            StatefulNavigationShell.of(context).goBranch(1);
                          },
                          onTaskTap: (task) async {
                            final cubit = context.read<HomeCubit>();
                            final changed = await context.push<bool>(
                              Routes.taskDetails,
                              extra: task.id,
                            );
                            if (changed == true && context.mounted) {
                              final userId = LocalAppStorage.getUserId();
                              if (userId != null) {
                                await LocalAppStorage.invalidateCacheByPrefix(
                                  'today_tasks_${userId}_',
                                );
                                await LocalAppStorage.invalidateCache(
                                  'vol_stats_v2_$userId',
                                );
                                cubit.loadHome(userId);
                              }
                            }
                          },
                        ),
                        SizedBox(height: AppHeight.s100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Phase 1 tutorial — 4 steps on the home screen.
  // On finish → advanceToNextPhase() switches to Tasks tab (index 1).
  // ---------------------------------------------------------------------------
  void _showHomeTutorial() {
    final targets = <TargetFocus>[];
    const total = 4;

    if (_greetingKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'home_greeting',
          keyTarget: _greetingKey,
          title: 'الترحيب',
          description: 'هنا يظهر اسمك ومستواك الحالي',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: total,
        ),
      );
    }

    if (_statsGridKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'home_stats',
          keyTarget: _statsGridKey,
          title: 'إحصائياتك',
          description: 'ملخص أدائك: الساعات، المهام، النقاط، والتقييم',
          contentAlign: ContentAlign.bottom,
          stepIndex: 2,
          totalSteps: total,
        ),
      );
    }

    if (_todayTasksKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'home_today_tasks',
          keyTarget: _todayTasksKey,
          title: 'مهام اليوم',
          description:
              'المهام المطلوبة منك اليوم. اضغط على أي مهمة لعرض تفاصيلها',
          contentAlign: ContentAlign.top,
          stepIndex: 3,
          totalSteps: total,
        ),
      );
    }

    if (AppTutorialKeys.volunteerNotificationKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'home_notification',
          keyTarget: AppTutorialKeys.volunteerNotificationKey,
          title: 'الإشعارات',
          description: 'ستصلك هنا رسائل وتنبيهات المشرفين',
          contentAlign: ContentAlign.bottom,
          shape: ShapeLightFocus.Circle,
          stepIndex: 4,
          totalSteps: total,
        ),
      );
    }

    if (targets.isEmpty) {
      debugPrint(
        '📘 TUTORIAL: VolunteerHome screen has no targets, advancing to next phase',
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
