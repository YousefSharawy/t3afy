import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (message) => Center(
                child: Text(
                  message,
                  style: getRegularStyle(
                    fontSize: FontSize.s14,
                    fontFamily: FontConstants.fontFamily,
                    color: Colors.white70,
                  ),
                ),
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
                        style: getBoldStyle(
                          fontSize: FontSize.s20,
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.blueOne900,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Stats row
                      TasksHeaderStats(stats: stats),
                      SizedBox(height: 16.h),
                      TasksTabSwitcher(
                        selectedIndex: selectedTab,
                        todayCount: todayTasks.length,
                        completedCount: completedTasks.length,
                        onTabChanged: (index) {
                          context.read<TasksCubit>().switchTab(index);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Task list
                      Expanded(
                        child: tasks.isEmpty
                            ? Center(
                                child: Text(
                                  selectedTab == 0
                                      ? 'لا توجد مهام اليوم'
                                      : 'لا توجد مهام منجزة',
                                  style: getRegularStyle(
                                    fontSize: FontSize.s14,
                                    fontFamily: FontConstants.fontFamily,
                                    color: Colors.white54,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final taskItem = tasks[index];
                                  return TaskCard(
                                    task: taskItem,
                                    onTap: () {
                                      context.push(
                                        Routes.taskDetails,
                                        extra: taskItem.id,
                                      );
                                    },
                                  );
                                },
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
