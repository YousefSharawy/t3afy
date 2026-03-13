
import 'package:get_it/get_it.dart';
import 'package:t3afy/auth/data/repository/auth_impl_repository.dart';
import 'package:t3afy/auth/data/source/auth_impl_remote_data_source.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';
import 'package:t3afy/auth/domain/repository/auth_repository.dart';
import 'package:t3afy/auth/domain/use_cases/log_out_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/login_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/register_use_case.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/volunteer/home/data/repository/volunteer_impl_home_repository.dart';
import 'package:t3afy/volunteer/home/data/sources/volunteer_home_remote_data_source.dart';
import 'package:t3afy/volunteer/home/data/sources/volunteer_impl_home_remote_data_source.dart';
import 'package:t3afy/volunteer/home/domain/repository/home_repository.dart';
import 'package:t3afy/volunteer/home/domain/use_case/home_use_case.dart';
import 'package:t3afy/volunteer/home/representation/cubit/home_cubit.dart';
import 'package:t3afy/volunteer/profile/data/repository/profile_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/profile/data/source/profile_data_source.dart';
import 'package:t3afy/volunteer/profile/data/source/profile_impl_data_source.dart';
import 'package:t3afy/volunteer/profile/domain/repository/profile_repository.dart';
import 'package:t3afy/volunteer/profile/domain/use_cases/profile_use_case.dart';
import 'package:t3afy/volunteer/profile/presentation/cubit/profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> initAppModule() async {
  // Data source
  getIt.registerLazySingleton<AuthRemoteDateSource>(
    () => AuthImplRemoteDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthImplRepository(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<Login>(() => Login(getIt()));
  getIt.registerLazySingleton<Register>(() => Register(getIt()));

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt(), getIt(),getIt()));
getIt.registerFactory(() => HomeCubit(getIt(), getIt()));


  getIt.registerLazySingleton<VolunteerHomeRemoteDataSource>(
    () => VolunteerImplHomeRemoteDataSource(),
  );

  getIt.registerLazySingleton<VolunteerHomeRepository>(
    () => HomeImplRepository(getIt()),
  );

  getIt.registerLazySingleton(() => GetVolunteerStats(getIt()));
  getIt.registerLazySingleton(() => GetTodayTasks(getIt()));
getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileImplRemoteDataSource(),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileImplRepository(getIt()),
  );
getIt.registerLazySingleton<Logout>(() => Logout(getIt<AuthRepository>()));

  getIt.registerLazySingleton(() => GetProfile(getIt()));

  getIt.registerFactory(() => ProfileCubit(getIt()));
  // Cubit
}