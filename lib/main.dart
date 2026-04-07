import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:t3afy/firebase_options.dart';
import 'package:t3afy/translation/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  await LocalAppStorage.init();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: "${dotenv.env['SUPABASE_URL']}",
    anonKey: "${dotenv.env['SUPABASE_ANON_KEY']}",
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmService.init();
  await FcmService.setForegroundPresentationOptions();
  // await MobileAds.instance.initialize();

  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Future.delayed(const Duration(milliseconds: 200));
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
}

// dart run easy_localization:generate -S "assets/translation" -O "lib/translation"
// dart run easy_localization:generate -S "assets/translation" -O "lib/translation" -o "locale_keys.g.dart" -f keys
