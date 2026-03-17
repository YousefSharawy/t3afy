// routes.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/campaigns/presentation/view/campaigns_view.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaigns_cubit.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/admin/campaigns/presentation/view/campaign_detail_view.dart';
import 'package:t3afy/admin/campaigns/presentation/view/create_campaign_view.dart';
import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/admin/home/presentation/view/admin_home_view.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/admin/reports/presentation/view/admin_reports_view.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_cubit.dart';
import 'package:t3afy/admin/performance/presentation/view/admin_performance_view.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/volunteer_details_view.dart';
import 'package:t3afy/admin/volunteers/presentation/view/volunteers_panel_view.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/auth/presentation/view/login_view.dart';
import 'package:t3afy/auth/presentation/view/register_view.dart';
import 'package:t3afy/onBoarding/presentation/first_onboarding.dart';
import 'package:t3afy/splash/presentation/splash_view.dart';
import 'package:t3afy/splash/cubit/splash_cubit.dart';
import 'package:t3afy/volunteer/bot/presentation/cubit/chatbot_cubit.dart';
import 'package:t3afy/volunteer/bot/presentation/view/volunteer_bot_view.dart';
import 'package:t3afy/volunteer/performance/presentation/cubit/performance_cubit.dart';
import 'package:t3afy/volunteer/home/representation/cubit/home_cubit.dart';
import 'package:t3afy/volunteer/home/representation/volunteer_home_view.dart';
import 'package:t3afy/volunteer/maps/volunteer_map_view.dart';
import 'package:t3afy/volunteer/notifications/notifications_view.dart';
import 'package:t3afy/volunteer/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:t3afy/volunteer/performance/volunteer_performance_view.dart';
import 'package:t3afy/volunteer/profile/presentation/cubit/profile_cubit.dart';
import 'package:t3afy/volunteer/profile/presentation/view/volunteer_profile_view.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import 'package:t3afy/admin/profile/presentation/view/admin_profile_view.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/task_details_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/task_details_view.dart';
import 'package:t3afy/volunteer/tasks/presentation/view/volunteer_tasks_view.dart';

import '../../base/components.dart';

class Routes {
  static const String splash = '/';
  static const String onboarding1 = '/onboarding1';
  static const String login = '/login';
  static const String adminHome = '/adminHome';
  static const String register = '/register';
  static const String volunteerHome = '/volunteerHome';
  static const String volunteerTasks = '/volunteerTasks';
  static const String volunteerMap = '/volunteerMap';
  static const String volunteerPerformance = '/volunteerPerformance';
  static const String volunteerProfile = '/volunteerProfile';
  static const String taskDetails = '/taskDetails';
  static const String notifications = '/notifications';
  static const String bot = '/bot';
static const String volunteers = '/adminVolunteers';
  static const String campaigns = '/campaigns';
  static const String adminReports = '/adminReports';
  static const String campaignDetails = '/campaignDetails';
  static const String createCampaign = '/createCampaign';
  static const String editCampaign = '/editCampaign';
  static const String adminProfile = '/adminProfile';
  static const String volunteerDetails = '/volunteerDetails';
  static const String adminPerformance = '/adminPerformance';
}

class AppNavigation {
  AppNavigation._();

  static final _rootNK = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    navigatorKey: _rootNK,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => SplashCubit(),
            child: const SplashView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.onboarding1,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: const FirstOnboarding(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) =>
            CustomTransitionPage2(key: state.pageKey, child: const LoginView()),
      ),
      // GoRoute(
      //   path: Routes.adminHome,
      //   pageBuilder: (context, state) =>
      //       CustomTransitionPage2(key: state.pageKey, child: const AdminView()),
      // ),
      // GoRoute(
      //   path: Routes.adminReports,
      //   pageBuilder: (context, state) => CustomTransitionPage2(
      //     key: state.pageKey,
      //     child: const AdminReportsView(),
      //   ),
      // ),
      GoRoute(
        path: Routes.notifications,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<NotificationsCubit>(),
            child: const NotificationsView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: const RegisterView(),
        ),
      ),
      GoRoute(
        path: Routes.taskDetails,
        pageBuilder: (context, state) {
          final taskId = state.extra as String;
          return CustomTransitionPage2(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => getIt<TaskDetailsCubit>(),
              child: TaskDetailsView(taskId: taskId),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.volunteerProfile,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<ProfileCubit>(),
            child: const VolunteerProfileView(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.adminProfile,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<AdminProfileCubit>(),
            child: const AdminProfileView(),
          ),
        ),
      ),
      // Shell route with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
            debugPrint('🔑 Hive userId: ${LocalAppStorage.getUserId()}');

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<HomeCubit>()),
              BlocProvider(create: (_) => ChatbotCubit()),
              BlocProvider(create: (_) => getIt<PerformanceCubit>()),
  //              BlocProvider(
  //   create: (_) {
  //     debugPrint('🟡 Creating OnlineStatusCubit...');
  //     return getIt<OnlineStatusCubit>();
  //   },
  // ),
            ],
            child: VolunteerScaffoldWithNavBar(
              navigationShell: navigationShell,
            ),
          );
        },
        branches: <StatefulShellBranch>[
          // Tab 0: Home
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.volunteerHome,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: const VolunteerHomeView(),
                ),
              ),
            ],
          ),
          // Tab 1: Tasks
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/volunteerTasks',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<TasksCubit>(),
                  child: const VolunteerTasksView(),
                ),
              ),
            ],
          ),
          // Tab 2: Map
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.volunteerMap,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: const VolunteerMapView(),
                ),
              ),
            ],
          ),
          // Tab 3: Performance
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.volunteerPerformance,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: VolunteerPerformanceView(),
                ),
              ),
            ],
          ),
          // Tab 4: Bot
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.bot,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: VolunteerChatbotView(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/volunteerDetails/:id',
        pageBuilder: (context, state) {
          final volunteerId = state.pathParameters['id']!;
          return CustomTransitionPage2(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => getIt<VolunteerDetailsCubit>(),
              child: VolunteerDetailsView(volunteerId: volunteerId),
            ),
          );
        },
      ),
      GoRoute(
        path: '/campaignDetails/:id',
        pageBuilder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return CustomTransitionPage2(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => getIt<CampaignDetailCubit>(),
              child: CampaignDetailView(taskId: taskId),
            ),
          );
        },
      ),
      GoRoute(
        path: '/createCampaign',
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<CreateCampaignCubit>(),
            child: const CreateCampaignView(),
          ),
        ),
      ),
      GoRoute(
        path: '/editCampaign/:id',
        pageBuilder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return CustomTransitionPage2(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => getIt<CreateCampaignCubit>(),
              child: CreateCampaignView(taskId: taskId),
            ),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // Tab 0: Home
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.adminHome,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<AdminHomeCubit>(),
                    child: const AdminHomeView(),
                  ),
                ),
              ),
            ],
          ),
          // Tab 1: Volunteers
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.volunteers,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<VolunteersCubit>(),
                    child: const VolunteersPanelView(),
                  ),
                ),
              ),
            ],
          ),
          // Tab 2: Campaigns
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.campaigns,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: BlocProvider.value(
                    value: getIt<CampaignsCubit>(),
                    child: const CampaignsView(),
                  ),
                ),
              ),
            ],
          ),
          // Tab 3: Reports
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.adminReports,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<AdminReportsCubit>(),
                    child: const AdminReportsView(),
                  ),
                ),
              ),
            ],
          ),
          // Tab 4: Performance / Stats
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.adminPerformance,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<AdminPerformanceCubit>(),
                    child: const AdminPerformanceView(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class CustomTransitionPage extends Page {
  final Widget child;

  const CustomTransitionPage({required LocalKey key, required this.child})
    : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    const curve = Curves.easeOutSine;

    return MaterialPageRoute(
      settings: this,
      builder: (context) {
        final route = ModalRoute.of(context)!;
        final animation = route.animation!;

        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
          reverseCurve: curve.flipped,
        );

        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: curve,
                reverseCurve: curve.flipped,
              ),
            );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      fullscreenDialog: false,
    );
  }
}

class CustomTransitionPage2 extends Page {
  final Widget child;
  final Duration duration;

  const CustomTransitionPage2({
    required LocalKey key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(opacity: fadeAnimation, child: child);
      },
    );
  }
}
