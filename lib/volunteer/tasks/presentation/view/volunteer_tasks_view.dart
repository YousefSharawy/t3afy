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
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_state.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/tasks_card.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/tasks_header_states.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/widgets/tasks_tab_switcher.dart';

class VolunteerTasksView extends StatefulWidget {
  const VolunteerTasksView({super.key});

  @override
  State<VolunteerTasksView> createState() => _VolunteerTasksViewState();
}

class _VolunteerTasksViewState extends State<VolunteerTasksView> {
  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: SafeArea(
        child: BlocBuilder<TasksCubit, TasksState>(
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
                      SizedBox(height: AppHeight.s10,),
                      Text(
                        'المهام اليومية',
                        style: getExtraBoldStyle(
                          fontSize: FontSize.s16,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.natural900,
                        ),
                      ),
                      SizedBox(height: AppHeight.s24),
                      TasksHeaderStats(stats: stats),
                      SizedBox(height: AppHeight.s16),
                      TasksTabSwitcher(
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
                                      height: MediaQuery.of(context).size.height *
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
                                      task: taskItem,
                                      onTap: () async {
                                        final changed = await context.push<bool>(
                                          Routes.taskDetails,
                                          extra: taskItem.id,
                                        );
                                        if (changed == true) {
                                          final userId = LocalAppStorage.getUserId();
                                          if (userId != null) {
                                            await LocalAppStorage.invalidateCacheByPrefix('today_tasks_${userId}_');
                                            await LocalAppStorage.invalidateCache('completed_tasks_$userId');
                                            await LocalAppStorage.invalidateCache('tasks_stats_$userId');
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
        ) ),
    );
  }
}
