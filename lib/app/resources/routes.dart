// routes.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/admin_view.dart';
import 'package:t3afy/auth/presentation/view/login_view.dart';
import 'package:t3afy/auth/presentation/view/register_view.dart';
import 'package:t3afy/onBoarding/presentation/first_onboarding.dart';
import 'package:t3afy/splash/presentation/splash_view.dart';
import 'package:t3afy/splash/cubit/splash_cubit.dart';
import 'package:t3afy/volunteer/home/volunteer_home_view.dart';
import 'package:t3afy/volunteer/maps/volunteer_map_view.dart';
import 'package:t3afy/volunteer/performance/volunteer_performance_view.dart';
import 'package:t3afy/volunteer/profile/volunteer_profile_view.dart';
import 'package:t3afy/volunteer/tasks/volunteer_tasks_view.dart';

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
      GoRoute(
        path: Routes.adminHome,
        pageBuilder: (context, state) =>
            CustomTransitionPage2(key: state.pageKey, child: const AdminView()),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) => CustomTransitionPage2(
          key: state.pageKey,
          child: const RegisterView(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return VolunteerScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
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

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.volunteerTasks,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: const VolunteerTasksView(),
                ),
              ),
            ],
          ),

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
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.volunteerProfile,
                pageBuilder: (context, state) => CustomTransitionPage2(
                  key: state.pageKey,
                  child: VolunteerProfileView(),
                ),
              ),
            ],
          ),
        ],
      ),
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return AdminScaffoldWithNavBar(navigationShell: navigationShell);
      //   },
      //   branches: <StatefulShellBranch>[
      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.home,
      //           pageBuilder: (context, state) => CustomTransitionPage2(
      //             key: state.pageKey,
      //             child: const HomeView(),
      //           ),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.dictionary,
      //           pageBuilder: (context, state) => CustomTransitionPage2(
      //             key: state.pageKey,
      //             child: const DictionaryView(),
      //           ),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.study,
      //           pageBuilder: (context, state) => CustomTransitionPage2(
      //             key: state.pageKey,
      //             child: const StudyView(),
      //           ),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.profile,
      //           pageBuilder: (context, state) => CustomTransitionPage2(
      //             key: state.pageKey,
      //             child: ProfileView(),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
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

/// Custom transition with cross-fade masked by a diagonal light sweep.
/// The light travels from primary button area (bottom-right) to back button (top-left)
/// and back, creating continuity illusion rather than navigation feel.
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
