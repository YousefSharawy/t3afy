import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/volunteer/home/representation/cubit/home_cubit.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/greeting_card.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/stats_grid.dart';
import 'package:t3afy/volunteer/home/representation/view/widgets/todays_task_section.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
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

  VoidCallback? _tutorialListener;
  bool _tutorialShown = false;
  bool _welcomeOffered = false;

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

    _tutorialListener = _checkTutorial;
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener!);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
  }

  @override
  void dispose() {
    final listener = _tutorialListener;
    if (listener != null) {
      TutorialPhaseService.instance.phaseNotifier.removeListener(listener);
    }
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

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _showHomeTutorial();
    });
  }

  Future<void> _refresh() async {
    final ok = await context.read<HomeCubit>().refresh();
    if (!ok && mounted) {
      Toast.error.show(context, title: 'تعذر تحديث البيانات، حاول مرة أخرى');
    }
  }

  Future<void> _openTask(TaskEntity task) async {
    final cubit = context.read<HomeCubit>();
    final changed = await context.push<bool>(
      Routes.taskDetails,
      extra: task.id,
    );
    if (changed == true && mounted) cubit.refresh();
  }

  void _onLoaded() {
    // First-time flow: show welcome dialog then start tutorial.
    if (!_welcomeOffered &&
        !_tutorialShown &&
        !LocalAppStorage.isVolunteerTutorialCompleted() &&
        !TutorialPhaseService.instance.isRunning) {
      _welcomeOffered = true;
      TutorialService.showWelcomeOverlay(context, isAdmin: false).then((start) {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          AppPageHeader(
            title: 'الرئيسية',
            reserveBellSpace: true,
            leading: Padding(
              padding: EdgeInsetsDirectional.only(end: Space.s),
              child: IconButton.filledTonal(
                tooltip: 'الملف الشخصي',
                onPressed: () => context.push(Routes.volunteerProfile),
                style: IconButton.styleFrom(
                  backgroundColor: ColorManager.surface,
                  foregroundColor: ColorManager.brand,
                  minimumSize: Size.square(AppSizes.touch),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.small + 2),
                  ),
                ),
                icon: const Icon(AppIcons.person),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                state.maybeWhen(
                  loaded: (_, _, _) => _onLoaded(),
                  error: (message) {
                    if (message == HomeCubit.suspendedError) {
                      LocalAppStorage.clearUserSession();
                      context.go(Routes.login);
                    }
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                final data = state.maybeWhen(
                  loaded: (stats, tasks, _) => (stats: stats, tasks: tasks),
                  orElse: () => null,
                );
                final error = state.maybeWhen(
                  error: (m) => m == HomeCubit.suspendedError ? null : m,
                  orElse: () => null,
                );
                return AppAsyncBody(
                  hasData: data != null,
                  errorMessage: error,
                  onRetry: () {
                    final userId = LocalAppStorage.getUserId();
                    if (userId != null) {
                      context.read<HomeCubit>().loadHome(userId);
                    }
                  },
                  skeleton: const _HomeSkeleton(),
                  builder: (context) => _content(data!.stats, data.tasks),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(VolunteerStatsEntity stats, List<TaskEntity> tasks) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: Space.gutter,
          end: Space.gutter,
          top: Space.vxs,
          bottom: AppNavShell.bottomInset(context),
        ),
        children: [
          GreetingCard(
            key: _greetingKey,
            name: stats.name,
            level: stats.level,
            levelTitle: stats.levelTitle,
          ),
          SizedBox(height: Space.vl),
          const SectionHeader(title: 'إحصائياتي'),
          StatsGrid(
            key: _statsGridKey,
            placesVisited: stats.placesVisited,
            totalHours: stats.totalHours,
            rating: stats.rating,
            totalTasks: stats.totalTasks,
            totalPoints: stats.totalPoints,
          ),
          SizedBox(height: Space.vl),
          TodayTasksSection(
            key: _todayTasksKey,
            tasks: tasks,
            onViewAll: () => StatefulNavigationShell.of(context).goBranch(1),
            onTaskTap: _openTask,
          ),
        ],
      ),
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
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    TutorialService.buildPhaseContinuing(
      targets: targets,
      onFinish: TutorialPhaseService.instance.advanceToNextPhase,
    ).show(context: context, rootOverlay: true);
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget row(int n) => Row(
      children: [
        for (var i = 0; i < n; i++) ...[
          if (i > 0) SizedBox(width: Space.m),
          Expanded(child: SkeletonBox(height: 104, radius: Radii.card)),
        ],
      ],
    );
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: Space.gutter,
          end: Space.gutter,
          top: Space.vxs,
        ),
        children: [
          SkeletonBox(height: 128, radius: Radii.card),
          SizedBox(height: Space.vl),
          const SkeletonBox(width: 110, height: 18),
          SizedBox(height: Space.vm),
          row(3),
          SizedBox(height: Space.vm),
          row(2),
          SizedBox(height: Space.vl),
          const SkeletonBox(width: 110, height: 18),
          SizedBox(height: Space.vm),
          const SkeletonCard(),
          SizedBox(height: Space.vm),
          const SkeletonCard(),
        ],
      ),
    );
  }
}
