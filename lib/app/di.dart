
import 'package:get_it/get_it.dart';
import 'package:t3afy/auth/data/repository/auth_impl_repository.dart';
import 'package:t3afy/auth/data/source/auth_impl_remote_data_source.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';
import 'package:t3afy/auth/domain/repository/auth_repository.dart';
import 'package:t3afy/auth/domain/use_cases/login_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/register_use_case.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

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
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt(), getIt()));
}