import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/app_segmented_tabs.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_state.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/volunteer_task_card.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VolunteerTasksView extends StatefulWidget {
  const VolunteerTasksView({super.key});

  @override
  State<VolunteerTasksView> createState() => _VolunteerTasksViewState();
}

class _VolunteerTasksViewState extends State<VolunteerTasksView> {
  late final GlobalKey _tasksHeaderKey = GlobalKey(debugLabel: 'tasks_header');
  late final GlobalKey _tabSwitcherKey = GlobalKey(
    debugLabel: 'tasks_tab_switcher',
  );
  late final GlobalKey _taskCardKey = GlobalKey(debugLabel: 'tasks_first_card');
  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;
  TutorialCoachMark? _currentTutorial;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().loadTasks();

    _tutorialListener = () => _checkTutorial();
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkTutorial();
    });
  }

  @override
  void dispose() {
    TutorialPhaseService.instance.phaseNotifier.removeListener(
      _tutorialListener,
    );
    _currentTutorial?.skip();
    _currentTutorial = null;
    super.dispose();
  }

  void _checkTutorial() {
    final svc = TutorialPhaseService.instance;
    if (!svc.isRunning) return;
    if (svc.currentPhase != 2 || svc.isAdmin) return;
    if (_lastCheckedPhase == 2) return; // Already SHOWED phase 2

    final cubit = context.read<TasksCubit>();
    final state = cubit.state;

    state.maybeWhen(
      loaded: (_, _, _, _, _) {
        _lastCheckedPhase = 2; // Mark as processed ONLY when state is loaded
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          _showTasksTutorial();
        });
      },
      orElse: () {
        // Don't set _lastCheckedPhase yet - wait for state to load
      },
    );
  }

  void _showTasksTutorial() {
    final targets = <TargetFocus>[];


    // Build targets — only add if key has context
    if (_tasksHeaderKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'tasks_header_stats',
          keyTarget: _tasksHeaderKey,
          title: 'إحصائيات المهام',
          description: 'عدد مهام اليوم والمهام المنجزة وإجمالي النقاط المكتسبة',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: 2,
        ),
      );
    }

    if (_tabSwitcherKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'tasks_tab_switcher',
          keyTarget: _tabSwitcherKey,
          title: 'تبديل العرض',
          description:
              'تنقل بين مهام اليوم والمهام القادمة والمنجزة. افتح أي مهمة لترى موقعها وأوراقها وتفاصيلها',
          contentAlign: ContentAlign.bottom,
          stepIndex: 2,
          totalSteps: 2,
        ),
      );
    }

    if (targets.isEmpty) {
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }


    void onTutorialComplete() {
      _currentTutorial = null;
      TutorialPhaseService.instance.advanceToNextPhase();
    }

    _currentTutorial = TutorialService.buildPhaseContinuing(
      targets: targets,
      onFinish: onTutorialComplete,
      onSkip: onTutorialComplete,
    );

    _currentTutorial?.show(context: context, rootOverlay: true);
  }

  Future<void> _refresh() async {
    final ok = await context.read<TasksCubit>().refresh();
    if (!ok && mounted) {
      Toast.error.show(context, title: 'تعذر تحديث المهام، حاول مرة أخرى');
    }
  }

  Future<void> _openTask(TaskEntity task) async {
    final cubit = context.read<TasksCubit>();
    final changed = await context.push<bool>(
      Routes.taskDetails,
      extra: task.id,
    );
    if (changed == true && mounted) cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppPageHeader(title: 'المهام', reserveBellSpace: true),
          Expanded(
            child: BlocConsumer<TasksCubit, TasksState>(
              listenWhen: (prev, curr) =>
                  curr is TasksStateLoaded && prev is! TasksStateLoaded,
              listener: (context, state) {
                // GlobalKeys are valid now — trigger tutorial if it was waiting.
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _checkTutorial(),
                );
              },
              builder: (context, state) {
                return AppAsyncBody(
                  hasData: state is TasksStateLoaded,
                  errorMessage: state is TasksStateError ? state.message : null,
                  onRetry: () => context.read<TasksCubit>().loadTasks(),
                  skeleton: const _TasksSkeleton(),
                  builder: (context) => _content(state as TasksStateLoaded),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(TasksStateLoaded state) {
    final tab = state.selectedTab;
    final tasks = switch (tab) {
      0 => state.todayTasks,
      1 => state.upcomingTasks,
      _ => state.completedTasks,
    };
    final stats = state.stats;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsetsDirectional.only(
              start: Space.gutter,
              end: Space.gutter,
              top: Space.vxs,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IntrinsicHeight(
                    key: _tasksHeaderKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: StatTile(
                            value: '${stats.todayCount}',
                            label: 'اليوم',
                            icon: AppIcons.calendar,
                          ),
                        ),
                        SizedBox(width: Space.m),
                        Expanded(
                          child: StatTile(
                            value: '${stats.completedCount}',
                            label: 'مكتملة',
                            icon: AppIcons.done,
                            tint: ColorManager.sprout,
                          ),
                        ),
                        SizedBox(width: Space.m),
                        Expanded(
                          child: StatTile(
                            value: '${stats.earnedPoints}',
                            label: 'النقاط المكتسبة',
                            icon: AppIcons.medal,
                            tint: ColorManager.brandStrong,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Space.vl),
                  AppSegmentedTabs(
                    key: _tabSwitcherKey,
                    labels: const ['اليوم', 'القادمة', 'المنجزة'],
                    counts: [
                      state.todayTasks.length,
                      state.upcomingTasks.length,
                      state.completedTasks.length,
                    ],
                    selectedIndex: tab,
                    onChanged: context.read<TasksCubit>().switchTab,
                  ),
                  SizedBox(height: Space.vm),
                ],
              ),
            ),
          ),
          if (tasks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: AppNavShell.bottomInset(context),
                ),
                child: switch (tab) {
                  0 => const AppEmptyState(
                    icon: AppIcons.tasks,
                    title: 'لا توجد مهام اليوم',
                    message: 'عندما تُسند إليك مهمة لهذا اليوم ستظهر هنا',
                  ),
                  1 => const AppEmptyState(
                    icon: AppIcons.calendar,
                    title: 'لا توجد مهام قادمة',
                    message: 'المهام المُسندة إليك في الأيام القادمة ستظهر هنا',
                  ),
                  _ => const AppEmptyState(
                    icon: AppIcons.done,
                    title: 'لا توجد مهام منجزة بعد',
                    message: 'المهام التي تنجزها ستظهر هنا مع نقاطها',
                  ),
                },
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsetsDirectional.only(
                start: Space.gutter,
                end: Space.gutter,
                bottom: AppNavShell.bottomInset(context),
              ),
              sliver: SliverList.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, _) => SizedBox(height: Space.vm),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return VolunteerTaskCard(
                    key: index == 0 ? _taskCardKey : ValueKey(task.id),
                    task: task,
                    showDate: tab != 0,
                    onTap: () => _openTask(task),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _TasksSkeleton extends StatelessWidget {
  const _TasksSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: Space.gutter,
          end: Space.gutter,
          top: Space.vxs,
        ),
        children: [
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) SizedBox(width: Space.m),
                Expanded(child: SkeletonBox(height: 104, radius: Radii.card)),
              ],
            ],
          ),
          SizedBox(height: Space.vl),
          SkeletonBox(height: 44, radius: Radii.input),
          SizedBox(height: Space.vm),
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) SizedBox(height: Space.vm),
            const SkeletonCard(height: 132),
          ],
        ],
      ),
    );
  }
}
