
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
import 'package:t3afy/volunteer/performance/data/repository/performance_impl_repository.dart';
import 'package:t3afy/volunteer/performance/data/sources/performance_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/performance/data/sources/performance_remote_data_source.dart';
import 'package:t3afy/volunteer/performance/domain/repository/performance_repository.dart';
import 'package:t3afy/volunteer/performance/domain/use_cases/performance_use_cases.dart';
import 'package:t3afy/volunteer/performance/presentation/cubit/performance_cubit.dart';
import 'package:t3afy/volunteer/profile/data/repository/profile_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/profile/data/source/profile_data_source.dart';
import 'package:t3afy/volunteer/profile/data/source/profile_impl_data_source.dart';
import 'package:t3afy/volunteer/profile/domain/repository/profile_repository.dart';
import 'package:t3afy/volunteer/profile/domain/use_cases/profile_use_case.dart';
import 'package:t3afy/volunteer/profile/presentation/cubit/profile_cubit.dart';
import 'package:t3afy/volunteer/tasks/data/repository/tasks_impl_repository.dart';
import 'package:t3afy/volunteer/tasks/data/sources/tasks_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/tasks/data/sources/tasks_remote_data_source.dart';
import 'package:t3afy/volunteer/tasks/domain/repository/tasks_repository.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_completed_tasks.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_tasks_stats.dart';
import 'package:t3afy/volunteer/tasks/domain/use_cases/get_today_tasks.dart';
import 'package:t3afy/volunteer/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:t3afy/volunteer/task_details/data/sources/task_details_remote_data_source.dart';
import 'package:t3afy/volunteer/task_details/data/sources/task_details_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/task_details/data/repository/task_details_impl_repository.dart';
import 'package:t3afy/volunteer/task_details/domain/repository/task_details_repository.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/get_task_details_use_case.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/task_details_cubit.dart';
import 'package:t3afy/volunteer/task_details/data/sources/report_remote_data_source.dart';
import 'package:t3afy/volunteer/task_details/data/sources/report_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/task_details/data/repository/report_impl_repository.dart';
import 'package:t3afy/volunteer/task_details/domain/repository/report_repository.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/submit_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';

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
  getIt.registerLazySingleton(() => GetHomeTodayTasks(getIt()));
getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileImplRemoteDataSource(),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileImplRepository(getIt()),
  );
getIt.registerLazySingleton<Logout>(() => Logout(getIt<AuthRepository>()));

  getIt.registerLazySingleton(() => GetProfile(getIt()));

  getIt.registerFactory(() => ProfileCubit(getIt()));

  // ── Performance ──
  getIt.registerLazySingleton<PerformanceRemoteDataSource>(
    () => PerformanceImplRemoteDataSource(),
  );

  getIt.registerLazySingleton<PerformanceRepository>(
    () => PerformanceImplRepository(getIt()),
  );

  getIt.registerLazySingleton(() => GetPerformanceStats(getIt()));
  getIt.registerLazySingleton(() => GetMonthlyHours(getIt()));
  getIt.registerLazySingleton(() => GetLeaderboard(getIt()));

  getIt.registerFactory(() => PerformanceCubit(getIt(), getIt(), getIt()));




  // ===== Tasks =====
// Data source
getIt.registerLazySingleton<TasksRemoteDataSource>(
  () => TasksImplRemoteDataSource(Supabase.instance.client),
);

// Repository
getIt.registerLazySingleton<TasksRepository>(
  () => TasksImplRepository(getIt<TasksRemoteDataSource>()),
);

// Use cases
getIt.registerLazySingleton(() => GetTodayTasks(getIt<TasksRepository>()));
getIt.registerLazySingleton(() => GetCompletedTasks(getIt<TasksRepository>()));
getIt.registerLazySingleton(() => GetTasksStats(getIt<TasksRepository>()));

// Cubit
getIt.registerFactory(() => TasksCubit(
  getIt<GetTodayTasks>(),
  getIt<GetCompletedTasks>(),
  getIt<GetTasksStats>(),
));

  // ===== Task Details =====
  getIt.registerLazySingleton<TaskDetailsRemoteDataSource>(
    () => TaskDetailsImplRemoteDataSource(),
  );
  getIt.registerLazySingleton<TaskDetailsImplRemoteDataSource>(
    () => getIt<TaskDetailsRemoteDataSource>() as TaskDetailsImplRemoteDataSource,
  );
  getIt.registerLazySingleton<TaskDetailsRepository>(
    () => TaskDetailsImplRepository(getIt<TaskDetailsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetTaskDetailsUseCase(getIt<TaskDetailsRepository>()),
  );
  getIt.registerFactory(
    () => TaskDetailsCubit(
      getIt<GetTaskDetailsUseCase>(),
      getIt<TaskDetailsImplRemoteDataSource>(),
    ),
  );

  // ===== Report =====
  getIt.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportImplRemoteDataSource(),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportImplRepository(getIt<ReportRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => SubmitReportUseCase(getIt<ReportRepository>()),
  );
  getIt.registerFactory(
    () => ReportCubit(getIt<SubmitReportUseCase>()),
  );
}