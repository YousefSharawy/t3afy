
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
import 'package:t3afy/volunteer/task_details/domain/use_cases/get_existing_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/domain/use_cases/submit_report_use_case.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/notifications/data/sources/notifications_remote_data_source.dart';
import 'package:t3afy/volunteer/notifications/data/sources/notifications_impl_remote_data_source.dart';
import 'package:t3afy/volunteer/notifications/data/repository/notifications_impl_repository.dart';
import 'package:t3afy/volunteer/notifications/domain/repository/notifications_repository.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_as_read_use_case.dart';
import 'package:t3afy/volunteer/notifications/domain/use_cases/mark_all_as_read_use_case.dart';
import 'package:t3afy/volunteer/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource.dart';
import 'package:t3afy/admin/reports/data/datasources/admin_reports_remote_datasource_impl.dart';
import 'package:t3afy/admin/reports/data/repos/admin_reports_repo_impl.dart';
import 'package:t3afy/admin/reports/domain/repos/admin_reports_repo.dart';
import 'package:t3afy/admin/reports/domain/usecases/get_reports_usecase.dart';
import 'package:t3afy/admin/reports/domain/usecases/review_report_usecase.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/admin/home/data/datasources/admin_home_remote_datasource.dart';
import 'package:t3afy/admin/home/data/datasources/admin_home_remote_datasource_impl.dart';
import 'package:t3afy/admin/home/data/repos/admin_home_repo_impl.dart';
import 'package:t3afy/admin/home/domain/repos/admin_home_repo.dart';
import 'package:t3afy/admin/home/domain/usecases/get_admin_home_data_usecase.dart';
import 'package:t3afy/admin/home/domain/usecases/send_announcement_usecase.dart';
import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/admin/campaigns/data/datasources/campaigns_remote_datasource.dart';
import 'package:t3afy/admin/campaigns/data/datasources/campaigns_remote_datasource_impl.dart';
import 'package:t3afy/admin/campaigns/data/repos/campaigns_repo_impl.dart';
import 'package:t3afy/admin/campaigns/domain/repos/campaigns_repo.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaigns_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_stats_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_detail_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/create_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/update_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/delete_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/assign_volunteer_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/remove_volunteer_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/send_team_alert_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_unassigned_volunteers_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_all_volunteers_usecase.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaigns_cubit.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/admin/volunteers/data/datasources/volunteers_remote_datasource.dart';
import 'package:t3afy/admin/volunteers/data/datasources/volunteers_remote_datasource_impl.dart';
import 'package:t3afy/admin/volunteers/data/repos/volunteers_repo_impl.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/add_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/approve_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/delete_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteer_details_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteers_usecase.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/services/online_status_cubit.dart';
import 'package:t3afy/admin/performance/data/datasources/admin_performance_remote_datasource.dart';
import 'package:t3afy/admin/performance/data/datasources/admin_performance_remote_datasource_impl.dart';
import 'package:t3afy/admin/performance/data/repos/admin_performance_repo_impl.dart';
import 'package:t3afy/admin/performance/domain/repos/admin_performance_repo.dart';
import 'package:t3afy/admin/performance/domain/usecases/get_admin_performance_usecase.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_cubit.dart';
import 'package:t3afy/admin/profile/data/datasources/admin_profile_remote_datasource.dart';
import 'package:t3afy/admin/profile/data/datasources/admin_profile_remote_datasource_impl.dart';
import 'package:t3afy/admin/profile/data/repos/admin_profile_repo_impl.dart';
import 'package:t3afy/admin/profile/domain/repos/admin_profile_repo.dart';
import 'package:t3afy/admin/profile/domain/usecases/get_admin_profile_usecase.dart';
import 'package:t3afy/admin/profile/domain/usecases/update_admin_profile_usecase.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';

final getIt = GetIt.instance;

Future<void> initAppModule() async {
  // Services
  getIt.registerFactory<OnlineStatusCubit>(
    () => OnlineStatusCubit(Supabase.instance.client),
  );

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
  getIt.registerLazySingleton(
    () => GetExistingReportUseCase(getIt<ReportRepository>()),
  );
  getIt.registerFactory(
    () => ReportCubit(
      getIt<SubmitReportUseCase>(),
      getIt<GetExistingReportUseCase>(),
    ),
  );

  // ===== Notifications =====
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsImplRemoteDataSource(),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsImplRepository(getIt<NotificationsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetNotificationsUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkAsReadUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkAllAsReadUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerFactory(
    () => NotificationsCubit(
      getIt<GetNotificationsUseCase>(),
      getIt<MarkAsReadUseCase>(),
      getIt<MarkAllAsReadUseCase>(),
    ),
  );

  getIt.registerLazySingleton<AdminReportsRemoteDatasource>(
    () => AdminReportsRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<AdminReportsRepo>(
    () => AdminReportsRepoImpl(getIt<AdminReportsRemoteDatasource>()),
  );
  getIt.registerLazySingleton(() => GetReportsUsecase(getIt<AdminReportsRepo>()));
  getIt.registerLazySingleton(
      () => ReviewReportUsecase(getIt<AdminReportsRepo>()));
  getIt.registerFactory(
    () => AdminReportsCubit(
      getIt<GetReportsUsecase>(),
      getIt<ReviewReportUsecase>(),
      getIt<AdminReportsRepo>(),
    ),
  );

  getIt.registerLazySingleton<AdminHomeRemoteDatasource>(
    () => AdminHomeRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<AdminHomeRepo>(
    () => AdminHomeRepoImpl(getIt<AdminHomeRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminHomeDataUsecase(getIt<AdminHomeRepo>()),
  );
  getIt.registerLazySingleton(
    () => SendAnnouncementUsecase(getIt<AdminHomeRepo>()),
  );
  getIt.registerFactory(
    () => AdminHomeCubit(
      getIt<GetAdminHomeDataUsecase>(),
      getIt<SendAnnouncementUsecase>(),
      getIt<AdminHomeRepo>(),
    ),
  );

  // ===== Campaigns =====
  getIt.registerLazySingleton<CampaignsRemoteDatasource>(
    () => CampaignsRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<CampaignsRepo>(
    () => CampaignsRepoImpl(getIt<CampaignsRemoteDatasource>()),
  );
  getIt.registerLazySingleton(() => GetCampaignsUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => GetCampaignStatsUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => GetCampaignDetailUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => CreateCampaignUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => UpdateCampaignUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => DeleteCampaignUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => AssignVolunteerUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => RemoveVolunteerUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => SendTeamAlertUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => GetUnassignedVolunteersUsecase(getIt<CampaignsRepo>()));
  getIt.registerLazySingleton(() => GetAllVolunteersUsecase(getIt<CampaignsRepo>()));
  getIt.registerFactory(
    () => CreateCampaignCubit(
      getIt<GetAllVolunteersUsecase>(),
      getIt<GetCampaignDetailUsecase>(),
      getIt<CreateCampaignUsecase>(),
      getIt<UpdateCampaignUsecase>(),
    ),
  );
  getIt.registerLazySingleton(
    () => CampaignsCubit(
      getIt<GetCampaignsUsecase>(),
      getIt<GetCampaignStatsUsecase>(),
      getIt<CampaignsRepo>(),
    ),
  );
  getIt.registerFactory(
    () => CampaignDetailCubit(
      getIt<GetCampaignDetailUsecase>(),
      getIt<AssignVolunteerUsecase>(),
      getIt<RemoveVolunteerUsecase>(),
      getIt<SendTeamAlertUsecase>(),
      getIt<DeleteCampaignUsecase>(),
      getIt<UpdateCampaignUsecase>(),
      getIt<GetUnassignedVolunteersUsecase>(),
    ),
  );

  // ===== Admin Profile =====
  getIt.registerLazySingleton<AdminProfileRemoteDatasource>(
    () => AdminProfileRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<AdminProfileRepo>(
    () => AdminProfileRepoImpl(getIt<AdminProfileRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminProfileUsecase(getIt<AdminProfileRepo>()),
  );
  getIt.registerLazySingleton(
    () => UpdateAdminProfileUsecase(getIt<AdminProfileRepo>()),
  );
  getIt.registerFactory(
    () => AdminProfileCubit(
      getIt<GetAdminProfileUsecase>(),
      getIt<UpdateAdminProfileUsecase>(),
    ),
  );

  // ===== Volunteers =====
  getIt.registerLazySingleton<VolunteersRemoteDatasource>(
    () => VolunteersRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<VolunteersRepo>(
    () => VolunteersRepoImpl(getIt<VolunteersRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => GetVolunteersUsecase(getIt<VolunteersRepo>()),
  );
  getIt.registerLazySingleton(
    () => AddVolunteerUsecase(getIt<VolunteersRepo>()),
  );
  getIt.registerLazySingleton(
    () => GetVolunteerDetailsUsecase(getIt<VolunteersRepo>()),
  );
  getIt.registerLazySingleton(
    () => DeleteVolunteerUsecase(getIt<VolunteersRepo>()),
  );
  getIt.registerLazySingleton(
    () => ApproveVolunteerUsecase(getIt<VolunteersRepo>()),
  );
  getIt.registerFactory(
    () => VolunteersCubit(
      getIt<GetVolunteersUsecase>(),
      getIt<VolunteersRepo>(),
      getIt<AddVolunteerUsecase>(),
    ),
  );
  getIt.registerFactory(
    () => VolunteerDetailsCubit(
      getIt<GetVolunteerDetailsUsecase>(),
      getIt<DeleteVolunteerUsecase>(),
      getIt<ApproveVolunteerUsecase>(),
    ),
  );

  // ===== Admin Performance =====
  getIt.registerLazySingleton<AdminPerformanceRemoteDatasource>(
    () => AdminPerformanceRemoteDatasourceImpl(),
  );
  getIt.registerLazySingleton<AdminPerformanceRepo>(
    () => AdminPerformanceRepoImpl(getIt<AdminPerformanceRemoteDatasource>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminPerformanceUsecase(getIt<AdminPerformanceRepo>()),
  );
  getIt.registerFactory(
    () => AdminPerformanceCubit(getIt<GetAdminPerformanceUsecase>()),
  );
}