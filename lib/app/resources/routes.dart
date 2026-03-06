// routes.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/onBoarding/presentation/first_onboarding.dart';
import 'package:t3afy/splash/presentation/splash_view.dart';
import 'package:t3afy/splash/cubit/splash_cubit.dart';
class Routes {
  static const String splash = '/';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String home = '/home';
  static const String dictionary = '/dictionary';
  static const String study = '/study';
  static const String profile = '/profile';
  static const String savedItems = '/savedItems';
  static const String termDetails = '/termDetails';
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
        pageBuilder:
            (context, state) => CustomTransitionPage2(
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => SplashCubit(),
                child: const SplashView(),
              ),
            ),
      ),   
      GoRoute(
        path: Routes.onboarding1,
        pageBuilder:
            (context, state) => CustomTransitionPage2(
              key: state.pageKey,
              child: const FirstOnboarding(),
            ),
      ),

      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return ScaffoldWithNavBar(navigationShell: navigationShell);
      //   },
      //   branches: <StatefulShellBranch>[
      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.home,
      //           pageBuilder:
      //               (context, state) => CustomTransitionPage2(
      //                 key: state.pageKey,
      //                 child: const HomeView(),
      //               ),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.dictionary,
      //           pageBuilder:
      //               (context, state) => CustomTransitionPage2(
      //                 key: state.pageKey,
      //                 child: const DictionaryView(),
      //               ),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.study,
      //           pageBuilder:
      //               (context, state) => CustomTransitionPage2(
      //                 key: state.pageKey,
      //                 child: const StudyView(),
      //               ),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(
      //       routes: <RouteBase>[
      //         GoRoute(
      //           path: Routes.profile,
      //           pageBuilder:
      //               (context, state) => CustomTransitionPage2(
      //                 key: state.pageKey,
      //                 child: ProfileView(),
      //               ),
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

        final slideAnimation = Tween<Offset>(
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
