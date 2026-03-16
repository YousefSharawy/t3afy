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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((_) => AuthCubit(getIt(), getIt(), getIt()))),
        BlocProvider(
          lazy: false,
          create: (_) {
            debugPrint('🟡 Creating OnlineStatusCubit from MyApp...');
            return getIt<OnlineStatusCubit>();
          },
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
          );
        },
        designSize: const Size(375, 812),
      ),
    );
  }
}
