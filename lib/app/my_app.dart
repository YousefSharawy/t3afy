import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/services/online_status_cubit.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

import 'resources/constants_manager.dart';
import 'resources/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => getIt<OnlineStatusCubit>()),
        BlocProvider(
          create: (context) => AuthCubit(
            getIt(),
            getIt(),
            getIt(),
            context.read<OnlineStatusCubit>(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        ensureScreenSize: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: ConstantsManager.appName,
            theme: getApplicationTheme(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: AppNavigation.router,
            // App-wide default: dark status-bar icons on light screens. Dark
            // screens (splash, Manager home band) override it locally.
            builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        designSize: const Size(375, 812),
      ),
    );
  }
}
