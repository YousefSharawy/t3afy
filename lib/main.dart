import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/bloc_observer.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/fcm_service.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/my_app.dart';
import 'package:t3afy/app/resources/constants_manager.dart';
import 'package:t3afy/translation/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    LocalAppStorage.init(),
    dotenv.load(fileName: '.env'),
  ]);
  unawaited(LocalAppStorage.purgeExpiredCache());
  await Supabase.initialize(
    url: "${dotenv.env['SUPABASE_URL']}",
    anonKey: "${dotenv.env['SUPABASE_ANON_KEY']}",
  );
  await initAppModule();

  runApp(
    EasyLocalization(
      supportedLocales: const [ConstantsManager.arLocale],
      path: 'assets/translation',
      fallbackLocale: ConstantsManager.arLocale,
      startLocale: ConstantsManager.arLocale,
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );

  // Firebase/FCM (and the OS permission dialog) are not needed for the first
  // frame; FcmService awaits its own init wherever it is used.
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => FcmService.requestPermission(),
  );
}

// dart run easy_localization:generate -S "assets/translation" -O "lib/translation"
// dart run easy_localization:generate -S "assets/translation" -O "lib/translation" -o "locale_keys.g.dart" -f keys
