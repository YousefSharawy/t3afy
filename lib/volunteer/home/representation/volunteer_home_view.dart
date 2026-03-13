import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
    context.read<HomeCubit>().loadHome(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: ColorManager.blueOne600),
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.error,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  SizedBox(height: AppHeight.s16),
                  GestureDetector(
                    onTap: () {
                      final userId = LocalAppStorage.getUserId();
                      if (userId != null) {
                        context.read<HomeCubit>().loadHome(userId);
                      }
                    },
                    child: Text(
                      'إعادة المحاولة',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blueOne600,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loaded: (stats, todayTasks) => SingleChildScrollView(
              padding: EdgeInsets.only(left: AppWidth.s18, right: AppWidth.s18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppHeight.s10),
                  HomeAppBar(
                    onProfileTap: () {
                      context.push(Routes.volunteerProfile);
                    },
                    onNotificationTap: () {
                      context.push(Routes.notifications);
                    },
                  ),
                  SizedBox(height: AppHeight.s24),
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
                      color: ColorManager.blueOne900,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  SizedBox(height: AppHeight.s12),
                  StatsGrid(
                    placesVisited: stats.placesVisited,
                    totalHours: stats.totalHours,
                    rating: stats.rating,
                    totalTasks: stats.totalTasks,
                  ),
                  SizedBox(height: AppHeight.s16),
                  TodayTasksSection(
                    tasks: todayTasks,
                    onViewAll: () {
                      context.push(Routes.volunteerTasks);
                    },
                    onTaskTap: (task) {
                      context.push(Routes.taskDetails, extra: task.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
