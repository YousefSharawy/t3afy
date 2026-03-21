import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class VolunteerHomeView extends StatefulWidget {
  const VolunteerHomeView({super.key});

  @override
  State<VolunteerHomeView> createState() => _VolunteerHomeViewState();
}

class _VolunteerHomeViewState extends State<VolunteerHomeView> {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const LoadingIndicator(),
          error: (message) => ErrorState(
            message: message,
            onRetry: () {
              final userId = LocalAppStorage.getUserId();
              if (userId != null) {
                context.read<HomeCubit>().loadHome(userId);
              }
            },
          ),
          loaded: (stats, todayTasks, unreadCount) => Column(
            children: [
              SizedBox(height: AppHeight.s45,),
              Padding(
                padding: EdgeInsets.only(
                  left: AppWidth.s18,
                  right: AppWidth.s18,
                  top: AppHeight.s10,
                ),
                child: HomeAppBar(
                  onProfileTap: () {
                    context.push(Routes.volunteerProfile);
                  },
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
                          placesVisited: stats.placesVisited,
                          totalHours: stats.totalHours,
                          rating: stats.rating,
                          totalTasks: stats.totalTasks,
                          totalPoints: stats.totalPoints,
                        ),
                        SizedBox(height: AppHeight.s8),
                        TodayTasksSection(
                          tasks: todayTasks,
                          onViewAll: () {
                            StatefulNavigationShell.of(context).goBranch(1);
                          },
                          onTaskTap: (task) {
                            context.push(Routes.taskDetails, extra: task.id);
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
}
