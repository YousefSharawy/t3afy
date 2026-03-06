// import 'package:get_it/get_it.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// final getIt = GetIt.instance;

// Future<void> initAppModule() async {
//   // TTS Service
//   getIt.registerLazySingleton<TtsService>(() => TtsService());

//   // Supabase client
//   getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

//   // Remote data source
//   getIt.registerLazySingleton<RemoteDataSource>(
//     () => RemoteDataSourceImpl(supabase: getIt()),
//   );

//   // Repository
//   getIt.registerLazySingleton<Repository>(() => RepositoryImpl(getIt()));

//   // Cubits
//   getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt()));
//   getIt.registerLazySingleton<SearchCubit>(() => SearchCubit(getIt()));
//   getIt.registerLazySingleton<TermsCubit>(() => TermsCubit(getIt(),getIt(),getIt()));
//   getIt.registerFactory<TermDetailsCubit>(() => TermDetailsCubit(getIt()));
//   getIt.registerFactory<AzListCubit>(() => AzListCubit());
//   getIt.registerLazySingleton<NavigationCubit>(() => NavigationCubit());
//   getIt.registerSingleton<AuthCubit>(AuthCubit(getIt()));


//     getIt.registerLazySingleton<AdRepository>(() => AdRepositoryImpl());
//   getIt.registerLazySingleton<AdViewModel>(() => AdViewModel(getIt()));
// }
