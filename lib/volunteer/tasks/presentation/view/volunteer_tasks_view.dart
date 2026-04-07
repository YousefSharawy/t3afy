import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_state.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/tasks_card.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/tasks_header_states.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/tasks_tab_switcher.dart';
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
      loaded: (_, _, _, _) {
        debugPrint('📘 TUTORIAL: Tasks state is LOADED, marking _lastCheckedPhase=2 and showing tutorial');
        _lastCheckedPhase = 2; // Mark as processed ONLY when state is loaded
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          _showTasksTutorial();
        });
      },
      orElse: () {
        debugPrint('📘 TUTORIAL: Tasks state still LOADING, will retry when loaded');
        // Don't set _lastCheckedPhase yet - wait for state to load
      },
    );
  }

  void _showTasksTutorial() {
    final targets = <TargetFocus>[];

    debugPrint('📘 TUTORIAL: Starting _showTasksTutorial for phase 2');
    debugPrint(
      '📘 TUTORIAL: _tasksHeaderKey: ${_tasksHeaderKey.currentContext != null}',
    );
    debugPrint(
      '📘 TUTORIAL: _tabSwitcherKey: ${_tabSwitcherKey.currentContext != null}',
    );
    debugPrint(
      '📘 TUTORIAL: _taskCardKey: ${_taskCardKey.currentContext != null}',
    );
    debugPrint(
      '📘 TUTORIAL: performanceTabKey: ${AppTutorialKeys.volunteerPerformanceTabKey.currentContext != null}',
    );

    // Build targets — only add if key has context
    if (_tasksHeaderKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'tasks_header_stats',
          keyTarget: _tasksHeaderKey,
          title: 'إحصائيات المهام 📈',
          description:
              'عدد مهام اليوم والمهام المنجزة وإجمالي النقاط المكتسبة',
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
              'تنقل بين مهام اليوم والمهام المنجزة. المهام المنجزة تظهر مع ساعاتها ونقاطها',
          contentAlign: ContentAlign.bottom,
          stepIndex: 2,
          totalSteps: 2,
        ),
      );
    }

    if (targets.isEmpty) {
      debugPrint('📘 TUTORIAL: Phase 2 NO TARGETS — auto-advancing');
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    debugPrint('📘 TUTORIAL: Phase 2 showing ${targets.length} targets');

    void onTutorialComplete() {
      debugPrint('📘 TUTORIAL: Phase 2 tutorial complete - advancing');
      _currentTutorial = null;
      TutorialPhaseService.instance.advanceToNextPhase();
    }

    _currentTutorial = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      hideSkip: false,
      textSkip: "تخطي",
      textStyleSkip: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: FontConstants.fontFamily,
      ),
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 600),
      onFinish: onTutorialComplete,
      onSkip: () {
        debugPrint('📘 TUTORIAL: Phase 2 skipped');
        onTutorialComplete();
        return true;
      },
    );

    debugPrint('📘 TUTORIAL: Calling .show() for phase 2');
    _currentTutorial?.show(context: context, rootOverlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: SafeArea(
        child: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (_, _, _, _) {
                // GlobalKeys are valid now — trigger tutorial if it was waiting.
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _checkTutorial(),
                );
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
                onRetry: () => context.read<TasksCubit>().loadTasks(),
              ),
              loaded: (todayTasks, completedTasks, stats, selectedTab) {
                final tasks = selectedTab == 0 ? todayTasks : completedTasks;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: AppHeight.s10),
                      Text(
                        'المهام اليومية',
                        style: getExtraBoldStyle(
                          fontSize: FontSize.s16,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.natural900,
                        ),
                      ),
                      SizedBox(height: AppHeight.s24),
                      TasksHeaderStats(key: _tasksHeaderKey, stats: stats),
                      SizedBox(height: AppHeight.s16),
                      TasksTabSwitcher(
                        key: _tabSwitcherKey,
                        selectedIndex: selectedTab,
                        todayCount: todayTasks.length,
                        completedCount: completedTasks.length,
                        onTabChanged: (index) {
                          context.read<TasksCubit>().switchTab(index);
                        },
                      ),
                      SizedBox(height: AppHeight.s24),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<TasksCubit>().loadTasks(),
                          color: const Color(0xFF00ABD2),
                          child: tasks.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.5,
                                      child: Center(
                                        child: Text(
                                          selectedTab == 0
                                              ? 'لا توجد مهام اليوم'
                                              : 'لا توجد مهام منجزة',
                                          style: getRegularStyle(
                                            fontSize: FontSize.s14,
                                            fontFamily:
                                                FontConstants.fontFamily,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    final taskItem = tasks[index];
                                    final cubit = context.read<TasksCubit>();
                                    return TaskCard(
                                      key: index == 0 ? _taskCardKey : null,
                                      task: taskItem,
                                      onTap: () async {
                                        final changed = await context
                                            .push<bool>(
                                              Routes.taskDetails,
                                              extra: taskItem.id,
                                            );
                                        if (changed == true) {
                                          final userId =
                                              LocalAppStorage.getUserId();
                                          if (userId != null) {
                                            await LocalAppStorage.invalidateCacheByPrefix(
                                              'today_tasks_${userId}_',
                                            );
                                            await LocalAppStorage.invalidateCache(
                                              'completed_tasks_$userId',
                                            );
                                            await LocalAppStorage.invalidateCache(
                                              'tasks_stats_$userId',
                                            );
                                          }
                                          cubit.loadTasks();
                                        }
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
