# Project Memory Profile — Full Codebase Scan

*Last updated: 2026-03-24 22:50:08*
*Generated automatically from codebase scan.*

## 1. Project Identity
- **App Name**: t3afy
- **Description**: A new Flutter project.
- **Version**: 1.0.0+1
- **Dart SDK**: >=3.10.3 <4.0.0
- **Supabase URL**: https://yjreaaxpacsrkpotljpf.supabase.co
- **Supabase Project Ref**: eyJhbGciOiJIUzI1NiIs... (derived from anon key or omitted)
- **Dependencies**: flutter, sdk, bloc, cherry_toast, cupertino_icons, dartz, easy_localization, flutter_bloc, flutter_rounded_progress_bar, flutter_screenutil, flutter_svg, freezed_annotation, get_it, go_router, internet_connection_checker, json_annotation, loader_overlay, shared_preferences, shimmer, file_picker, image_picker, permission_handler, dotted_border, supabase_flutter, flutter_launcher_icons, photo_view, fluttertoast, flutter_tts, cached_network_image, hive, hive_flutter, azlistview, scrollable_positioned_list, google_sign_in, url_launcher, flutter_dotenv, crypto, dotenv, freezed, flutter_map, latlong2, fl_chart
- **Design Base**: ScreenUtil (Derived from usage in main.dart / app code)
- **Locale Strategy**: `easy_localization` (Derived from dependencies)

## 2. Architecture Overview
### Directory Tree `lib/` (2 levels)
```text
- admin/
  - campaigns/
    - data/
    - domain/
    - presentation/
  - home/
    - data/
    - domain/
    - presentation/
  - notifications/
    - data/
    - domain/
    - presentation/
  - performance/
    - data/
    - domain/
    - presentation/
  - profile/
    - data/
    - domain/
    - presentation/
  - reports/
    - data/
    - domain/
    - presentation/
  - volunteers/
    - data/
    - domain/
    - presentation/
- app/
  - app_const.dart
  - app_prefs.dart
  - bloc_observer.dart
  - cubit/
    - navigation_cubit.dart
    - navigation_cubit.freezed.dart
    - navigation_state.dart
  - di.dart
  - error_handler.dart
  - extenstions.dart
  - failture.dart
  - local_storage.dart
  - my_app.dart
  - resources/
    - assets_manager.dart
    - color_manager.dart
    - constants_manager.dart
    - extenstions.dart
    - font_manager.dart
    - routes.dart
    - style_manager.dart
    - theme_manager.dart
    - values_manager.dart
  - services/
    - online_status_cubit.dart
  - ui_utiles.dart
- auth/
  - data/
    - mappers/
    - models/
    - repository/
    - source/
  - domain/
    - entity/
    - repository/
    - use_cases/
  - presentation/
    - cubit/
    - view/
- base/
  - components.dart
  - primary_widgets.dart
  - shimmers.dart
  - widgets/
    - app_form_field.dart
    - app_toast.dart
    - chip_badge.dart
    - confirm_dialog.dart
    - empty_state_text.dart
    - error_state.dart
    - filter_chip_item.dart
    - info_row.dart
    - loading_indicator.dart
    - nav_bar_item.dart
    - perf_stat_box.dart
    - primary_tab_bar.dart
    - profile_badge.dart
    - profile_header_card.dart
    - profile_info_section.dart
    - readonly_field.dart
    - section_label.dart
    - status_badge.dart
- main.dart
- onBoarding/
  - presentation/
    - first_onboarding.dart
- splash/
  - cubit/
    - splash_cubit.dart
    - splash_cubit.freezed.dart
    - splash_state.dart
  - presentation/
    - splash_view.dart
- translation/
  - codegen_loader.g.dart
  - locale_keys.g.dart
- volunteer/
  - bot/
    - presentation/
  - home/
    - data/
    - domain/
    - representation/
  - maps/
    - volunteer_map_view.dart
    - widgets/
  - models/
    - volunteer_stats_model.dart
    - volunteer_stats_model.freezed.dart
    - volunteer_stats_model.g.dart
  - notifications/
    - data/
    - domain/
    - helpers/
    - notifications_view.dart
    - presentation/
  - performance/
    - data/
    - domain/
    - presentation/
    - volunteer_performance_view.dart
  - profile/
    - data/
    - domain/
    - presentation/
  - task_details/
    - data/
    - domain/
    - presentation/
  - tasks/
    - data/
    - domain/
    - presentation/
```

### Layer Communication Pattern
`UI → Cubit → UseCase → Repository → DataSource → Supabase / LocalAppStorage Cache`

### Error Handling Pattern
Uses `dartz` `Either<Failure, T>` returning `Left(Failure(...))` on catch and `Right(data)` on success.

### Dependency Injection (lib/app/di.dart)
| Type | Class Registered | Interface |
|---|---|---|
| Factory | AdminHomeCubit | AdminHomeCubit |
| Factory | AuthCubit | AuthCubit |
| Factory | VolunteerDetailsCubit | VolunteerDetailsCubit |
| Factory | OnlineStatusCubit | OnlineStatusCubit |
| Factory | AdminNotificationsCubit | AdminNotificationsCubit |
| Factory | ReportCubit | ReportCubit |
| Factory | CampaignDetailCubit | CampaignDetailCubit |
| Factory | AdminReportsCubit | AdminReportsCubit |
| Factory | PerformanceCubit | PerformanceCubit |
| Factory | NotificationsCubit | NotificationsCubit |
| Factory | TaskDetailsCubit | TaskDetailsCubit |
| Factory | HomeCubit | HomeCubit |
| Factory | TasksCubit | TasksCubit |
| Factory | AdminPerformanceCubit | AdminPerformanceCubit |
| Factory | CreateCampaignCubit | CreateCampaignCubit |
| Factory | AdminProfileCubit | AdminProfileCubit |
| Factory | VolunteersCubit | VolunteersCubit |
| Factory | ProfileCubit | ProfileCubit |
| LazySingleton | GetCampaignDetailUsecase | GetCampaignDetailUsecase |
| LazySingleton | AssignTaskUsecase | AssignTaskUsecase |
| LazySingleton | GetAdminProfileUsecase | GetAdminProfileUsecase |
| LazySingleton | GetPerformanceStats | GetPerformanceStats |
| LazySingleton | VolunteerImplHomeRemoteDataSource | VolunteerHomeRemoteDataSource |
| LazySingleton | GetHomeTodayTasks | GetHomeTodayTasks |
| LazySingleton | SubmitReportUseCase | SubmitReportUseCase |
| LazySingleton | EditVolunteerDataUsecase | EditVolunteerDataUsecase |
| LazySingleton | GetLeaderboard | GetLeaderboard |
| LazySingleton | AdminHomeRemoteDatasourceImpl | AdminHomeRemoteDatasource |
| LazySingleton | AdminPerformanceRemoteDatasourceImpl | AdminPerformanceRemoteDatasource |
| LazySingleton | AdminNotificationsImplRemoteDataSource | AdminNotificationsRemoteDataSource |
| LazySingleton | MarkAllAdminNotificationsReadUseCase | MarkAllAdminNotificationsReadUseCase |
| LazySingleton | AdminProfileRemoteDatasourceImpl | AdminProfileRemoteDatasource |
| LazySingleton | UpdateAdminProfileUsecase | UpdateAdminProfileUsecase |
| LazySingleton | AuthImplRepository | AuthRepository |
| LazySingleton | AdminReportsRepoImpl | AdminReportsRepo |
| LazySingleton | AdminProfileRepoImpl | AdminProfileRepo |
| LazySingleton | SendAnnouncementUsecase | SendAnnouncementUsecase |
| LazySingleton | SuspendAccountUsecase | SuspendAccountUsecase |
| LazySingleton | AssignCustomTaskUsecase | AssignCustomTaskUsecase |
| LazySingleton | Register | Register |
| LazySingleton | GetAdminNotificationsUseCase | GetAdminNotificationsUseCase |
| LazySingleton | HomeImplRepository | VolunteerHomeRepository |
| LazySingleton | GetTasksStats | GetTasksStats |
| LazySingleton | GetVolunteerDetailsUsecase | GetVolunteerDetailsUsecase |
| LazySingleton | CampaignsRepoImpl | CampaignsRepo |
| LazySingleton | ReportImplRepository | ReportRepository |
| LazySingleton | PerformanceImplRepository | PerformanceRepository |
| LazySingleton | MarkAllAsReadUseCase | MarkAllAsReadUseCase |
| LazySingleton | NotificationsImplRepository | NotificationsRepository |
| LazySingleton | AddVolunteerUsecase | AddVolunteerUsecase |
| LazySingleton | CampaignsCubit | CampaignsCubit |
| LazySingleton | GetCompletedTasks | GetCompletedTasks |
| LazySingleton | SendTeamAlertUsecase | SendTeamAlertUsecase |
| LazySingleton | TasksImplRemoteDataSource | TasksRemoteDataSource |
| LazySingleton | GetCampaignStatsUsecase | GetCampaignStatsUsecase |
| LazySingleton | DeleteVolunteerUsecase | DeleteVolunteerUsecase |
| LazySingleton | AddRatingUsecase | AddRatingUsecase |
| LazySingleton | getIt<TaskDetailsRemoteDataSource> | TaskDetailsImplRemoteDataSource |
| LazySingleton | VolunteersRemoteDatasourceImpl | VolunteersRemoteDatasource |
| LazySingleton | DeleteCampaignUsecase | DeleteCampaignUsecase |
| LazySingleton | AdminReportsRemoteDatasourceImpl | AdminReportsRemoteDatasource |
| LazySingleton | ApproveVolunteerUsecase | ApproveVolunteerUsecase |
| LazySingleton | UpdateCampaignUsecase | UpdateCampaignUsecase |
| LazySingleton | ReportImplRemoteDataSource | ReportRemoteDataSource |
| LazySingleton | AssignVolunteerUsecase | AssignVolunteerUsecase |
| LazySingleton | VolunteersRepoImpl | VolunteersRepo |
| LazySingleton | GetAdminHomeDataUsecase | GetAdminHomeDataUsecase |
| LazySingleton | GetVolunteersUsecase | GetVolunteersUsecase |
| LazySingleton | Login | Login |
| LazySingleton | ProfileImplRemoteDataSource | ProfileRemoteDataSource |
| LazySingleton | GetAvailableTasksUsecase | GetAvailableTasksUsecase |
| LazySingleton | TaskDetailsImplRemoteDataSource | TaskDetailsRemoteDataSource |
| LazySingleton | AdminNotificationsImplRepository | AdminNotificationsRepository |
| LazySingleton | GetMonthlyHours | GetMonthlyHours |
| LazySingleton | AuthImplRemoteDataSource | AuthRemoteDateSource |
| LazySingleton | GetUnassignedVolunteersUsecase | GetUnassignedVolunteersUsecase |
| LazySingleton | CreateCampaignUsecase | CreateCampaignUsecase |
| LazySingleton | SendDirectMessageUsecase | SendDirectMessageUsecase |
| LazySingleton | GetPendingUsersUsecase | GetPendingUsersUsecase |
| LazySingleton | TasksImplRepository | TasksRepository |
| LazySingleton | GetAllVolunteersUsecase | GetAllVolunteersUsecase |
| LazySingleton | GetAdminPerformanceUsecase | GetAdminPerformanceUsecase |
| LazySingleton | Logout | Logout |
| LazySingleton | GetProfile | GetProfile |
| LazySingleton | GetExistingReportUseCase | GetExistingReportUseCase |
| LazySingleton | MarkAsReadUseCase | MarkAsReadUseCase |
| LazySingleton | RemoveVolunteerUsecase | RemoveVolunteerUsecase |
| LazySingleton | GetVolunteerStats | GetVolunteerStats |
| LazySingleton | GetReportsUsecase | GetReportsUsecase |
| LazySingleton | NotificationsImplRemoteDataSource | NotificationsRemoteDataSource |
| LazySingleton | AdminHomeRepoImpl | AdminHomeRepo |
| LazySingleton | ReviewReportUsecase | ReviewReportUsecase |
| LazySingleton | UpgradeLevelUsecase | UpgradeLevelUsecase |
| LazySingleton | GetNotificationsUseCase | GetNotificationsUseCase |
| LazySingleton | ProfileImplRepository | ProfileRepository |
| LazySingleton | GetCampaignsUsecase | GetCampaignsUsecase |
| LazySingleton | PerformanceImplRemoteDataSource | PerformanceRemoteDataSource |
| LazySingleton | GetTaskDetailsUseCase | GetTaskDetailsUseCase |
| LazySingleton | MarkAdminNotificationReadUseCase | MarkAdminNotificationReadUseCase |
| LazySingleton | CampaignsRemoteDatasourceImpl | CampaignsRemoteDatasource |
| LazySingleton | GetTodayTasks | GetTodayTasks |
| LazySingleton | AdminPerformanceRepoImpl | AdminPerformanceRepo |
| LazySingleton | TaskDetailsImplRepository | TaskDetailsRepository |

## 3. Supabase Database Schema (Inferred Tables)
| Table Name | Code Context / Extracted Details |
|---|---|
| `admin_notes` | Schema details implicitly handled by data sources |
| `assessments` | Schema details implicitly handled by data sources |
| `task_assignments` | Schema details implicitly handled by data sources |
| `task_objectives` | Schema details implicitly handled by data sources |
| `task_reports` | Schema details implicitly handled by data sources |
| `task_supplies` | Schema details implicitly handled by data sources |
| `tasks` | Schema details implicitly handled by data sources |
| `users` | Schema details implicitly handled by data sources |

> Note: Exact columns are hard to extract cleanly, see Model Catalogue below for field types.

## 4. Routing Config
| Name Constants | Path | File |
|---|---|---|
| `splash` | `/` | `app/resources/routes.dart` |
| `onboarding1` | `/onboarding1` | `app/resources/routes.dart` |
| `login` | `/login` | `app/resources/routes.dart` |
| `adminHome` | `/adminHome` | `app/resources/routes.dart` |
| `register` | `/register` | `app/resources/routes.dart` |
| `volunteerHome` | `/volunteerHome` | `app/resources/routes.dart` |
| `volunteerTasks` | `/volunteerTasks` | `app/resources/routes.dart` |
| `volunteerMap` | `/volunteerMap` | `app/resources/routes.dart` |
| `volunteerPerformance` | `/volunteerPerformance` | `app/resources/routes.dart` |
| `volunteerProfile` | `/volunteerProfile` | `app/resources/routes.dart` |
| `taskDetails` | `/taskDetails` | `app/resources/routes.dart` |
| `notifications` | `/notifications` | `app/resources/routes.dart` |
| `bot` | `/bot` | `app/resources/routes.dart` |
| `volunteers` | `/adminVolunteers` | `app/resources/routes.dart` |
| `campaigns` | `/campaigns` | `app/resources/routes.dart` |
| `adminReports` | `/adminReports` | `app/resources/routes.dart` |
| `campaignDetails` | `/campaignDetails` | `app/resources/routes.dart` |
| `createCampaign` | `/createCampaign` | `app/resources/routes.dart` |
| `editCampaign` | `/editCampaign` | `app/resources/routes.dart` |
| `adminProfile` | `/adminProfile` | `app/resources/routes.dart` |
| `volunteerDetails` | `/volunteerDetails` | `app/resources/routes.dart` |
| `adminPerformance` | `/adminPerformance` | `app/resources/routes.dart` |
| `adminNotifications` | `/adminNotifications` | `app/resources/routes.dart` |

## 5. State Management — Full Cubit Catalogue
### AdminHomeCubit
- **Path**: `admin/home/presentation/cubit/admin_home_cubit.dart`
- **State Class**: `AdminHomeState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: sendAnnouncement, close, loadDashboard
- **Use Cases Injected**: GetAdminHomeDataUsecase, AdminHomeRepo, SendAnnouncementUsecase
- **Realtime Subs**: False
- **Cache Usage**: True
### AdminNotificationsCubit
- **Path**: `admin/notifications/presentation/cubit/admin_notifications_cubit.dart`
- **State Class**: `AdminNotificationsState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: loadNotifications, close, markAsRead, markAllAsRead
- **Use Cases Injected**: GetAdminNotificationsUseCase, MarkAdminNotificationReadUseCase, MarkAllAdminNotificationsReadUseCase
- **Realtime Subs**: True
- **Cache Usage**: False
### AdminPerformanceCubit
- **Path**: `admin/performance/presentation/cubit/admin_performance_cubit.dart`
- **State Class**: `AdminPerformanceState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, loadPerformance
- **Use Cases Injected**: GetAdminPerformanceUsecase
- **Realtime Subs**: True
- **Cache Usage**: False
### AdminProfileCubit
- **Path**: `admin/profile/presentation/cubit/admin_profile_cubit.dart`
- **State Class**: `AdminProfileState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: loadProfile, updateProfile
- **Use Cases Injected**: GetAdminProfileUsecase, UpdateAdminProfileUsecase
- **Realtime Subs**: False
- **Cache Usage**: False
### AdminReportsCubit
- **Path**: `admin/reports/presentation/cubit/admin_reports_cubit.dart`
- **State Class**: `AdminReportsState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, loadReports, setFilter, reviewReport
- **Use Cases Injected**: AdminReportsRepo, ReviewReportUsecase, GetReportsUsecase
- **Realtime Subs**: False
- **Cache Usage**: True
### AuthCubit
- **Path**: `auth/presentation/cubit/auth_cubit.dart`
- **State Class**: `AuthState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: login, toggleRole, register, changeGender, logout
- **Use Cases Injected**: Login, Logout, Register
- **Realtime Subs**: False
- **Cache Usage**: True
### CampaignDetailCubit
- **Path**: `admin/campaigns/presentation/cubit/campaign_detail_cubit.dart`
- **State Class**: `CampaignDetailState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: pauseCampaign, getUnassignedVolunteers, deleteCampaign, close, assignVolunteers, removeVolunteer, load, sendAlert
- **Use Cases Injected**: DeleteCampaignUsecase, RemoveVolunteerUsecase, AssignVolunteerUsecase, GetCampaignDetailUsecase, GetUnassignedVolunteersUsecase, UpdateCampaignUsecase, SendTeamAlertUsecase
- **Realtime Subs**: True
- **Cache Usage**: True
### CampaignsCubit
- **Path**: `admin/campaigns/presentation/cubit/campaigns_cubit.dart`
- **State Class**: `CampaignsState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, setFilter, load
- **Use Cases Injected**: CampaignsRepo, GetCampaignsUsecase, GetCampaignStatsUsecase
- **Realtime Subs**: False
- **Cache Usage**: False
### ChatbotCubit
- **Path**: `volunteer/bot/presentation/cubit/chatbot_cubit.dart`
- **State Class**: `ChatbotState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: sendMessage
- **Use Cases Injected**: entry, keyword
- **Realtime Subs**: False
- **Cache Usage**: False
### CreateCampaignCubit
- **Path**: `admin/campaigns/presentation/cubit/create_campaign_cubit.dart`
- **State Class**: `CreateCampaignState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: addVolunteers, loadVolunteers, toggleVolunteer, save, loadForEdit
- **Use Cases Injected**: CreateCampaignUsecase, GetCampaignDetailUsecase, UpdateCampaignUsecase, GetAllVolunteersUsecase
- **Realtime Subs**: False
- **Cache Usage**: True
### HomeCubit
- **Path**: `volunteer/home/representation/cubit/home_cubit.dart`
- **State Class**: `HomeState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, loadHome, subscribeToUserUpdates
- **Use Cases Injected**: GetVolunteerStats, GetHomeTodayTasks
- **Realtime Subs**: True
- **Cache Usage**: False
### NavigationCubit
- **Path**: `app/cubit/navigation_cubit.dart`
- **State Class**: `NavigationState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: updateIndexImmediate, reset, close, updateIndex
- **Use Cases Injected**: None
- **Realtime Subs**: False
- **Cache Usage**: False
### NotificationsCubit
- **Path**: `volunteer/notifications/presentation/cubit/notifications_cubit.dart`
- **State Class**: `NotificationsState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: loadNotifications, close, markAsRead, markAllAsRead
- **Use Cases Injected**: MarkAsReadUseCase, GetNotificationsUseCase, MarkAllAsReadUseCase
- **Realtime Subs**: True
- **Cache Usage**: False
### OnlineStatusCubit
- **Path**: `app/services/online_status_cubit.dart`
- **State Class**: `OnlineStatusState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, didChangeAppLifecycleState
- **Use Cases Injected**: SupabaseClient
- **Realtime Subs**: False
- **Cache Usage**: True
### PerformanceCubit
- **Path**: `volunteer/performance/presentation/cubit/performance_cubit.dart`
- **State Class**: `PerformanceState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, loadPerformance
- **Use Cases Injected**: GetLeaderboard, GetMonthlyHours, GetPerformanceStats
- **Realtime Subs**: True
- **Cache Usage**: False
### ProfileCubit
- **Path**: `volunteer/profile/presentation/cubit/profile_cubit.dart`
- **State Class**: `ProfileState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, loadProfile
- **Use Cases Injected**: GetProfile
- **Realtime Subs**: True
- **Cache Usage**: False
### ReportCubit
- **Path**: `volunteer/task_details/presentation/cubit/report_cubit.dart`
- **State Class**: `ReportState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, submitReport, loadExistingReport
- **Use Cases Injected**: GetExistingReportUseCase, SubmitReportUseCase
- **Realtime Subs**: True
- **Cache Usage**: True
### SplashCubit
- **Path**: `splash/cubit/splash_cubit.dart`
- **State Class**: `SplashState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: start
- **Use Cases Injected**: None
- **Realtime Subs**: False
- **Cache Usage**: True
### TaskDetailsCubit
- **Path**: `volunteer/task_details/presentation/cubit/task_details_cubit.dart`
- **State Class**: `TaskDetailsState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: close, loadTaskDetails
- **Use Cases Injected**: GetTaskDetailsUseCase, TaskDetailsImplRemoteDataSource
- **Realtime Subs**: True
- **Cache Usage**: False
### TasksCubit
- **Path**: `volunteer/tasks/presentation/cubit/tasks_cubit.dart`
- **State Class**: `TasksState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: loadTasks, close, switchTab
- **Use Cases Injected**: GetCompletedTasks, GetTasksStats, GetTodayTasks
- **Realtime Subs**: True
- **Cache Usage**: True
### VolunteerDetailsCubit
- **Path**: `admin/volunteers/presentation/cubit/volunteer_details_cubit.dart`
- **State Class**: `VolunteerDetailsState` (Freezed: False)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: sendDirectMessage, editVolunteerData, suspendAccount, assignCustomTask, approveVolunteer, addRating, rejectVolunteer, deleteVolunteer, loadAvailableTasks, assignTask, load, upgradeLevel
- **Use Cases Injected**: SuspendAccountUsecase, DeleteVolunteerUsecase, AssignTaskUsecase, EditVolunteerDataUsecase, SendDirectMessageUsecase, UpgradeLevelUsecase, GetAvailableTasksUsecase, AddRatingUsecase, ApproveVolunteerUsecase, GetVolunteerDetailsUsecase, AssignCustomTaskUsecase
- **Realtime Subs**: False
- **Cache Usage**: False
### VolunteersCubit
- **Path**: `admin/volunteers/presentation/cubit/volunteers_cubit.dart`
- **State Class**: `VolunteersState` (Freezed: True)
- **State Variants**: [UNKNOWN / Initial] 
- **Public Methods**: addVolunteer, close, loadVolunteers, setFilter, loadPendingUsers, setSearchQuery
- **Use Cases Injected**: GetPendingUsersUsecase, GetVolunteersUsecase, AddVolunteerUsecase, VolunteersRepo
- **Realtime Subs**: False
- **Cache Usage**: False

## 6. Realtime Subscriptions Map
| Cubit/DataSource | Table | Event | Handler Method |
|---|---|---|---|

## 7. Data Source Methods
### AdminNotificationsImplRemoteDataSource
- **Path**: `admin/notifications/data/sources/admin_notifications_impl_remote_data_source.dart`
- **Tables Accessed**: admin_notes
- **Methods**: markAllAsRead, markAsRead
- **Cache Usage**: No
### AuthImplRemoteDataSource
- **Path**: `auth/data/source/auth_impl_remote_data_source.dart`
- **Tables Accessed**: users
- **Methods**: login, register, logout
- **Cache Usage**: No
### NotificationsImplRemoteDataSource
- **Path**: `volunteer/notifications/data/sources/notifications_impl_remote_data_source.dart`
- **Tables Accessed**: admin_notes
- **Methods**: markAllAsRead, markAsRead
- **Cache Usage**: No
### PerformanceImplRemoteDataSource
- **Path**: `volunteer/performance/data/sources/performance_impl_remote_data_source.dart`
- **Tables Accessed**: users, task_assignments
- **Methods**: getPerformanceStats
- **Cache Usage**: Yes (LocalAppStorage)
### ProfileImplRemoteDataSource
- **Path**: `volunteer/profile/data/source/profile_impl_data_source.dart`
- **Tables Accessed**: users
- **Methods**: getProfile
- **Cache Usage**: Yes (LocalAppStorage)
### ReportImplRemoteDataSource
- **Path**: `volunteer/task_details/data/sources/report_impl_remote_data_source.dart`
- **Tables Accessed**: task_assignments, task_reports
- **Methods**: submitReport
- **Cache Usage**: No
### TaskDetailsImplRemoteDataSource
- **Path**: `volunteer/task_details/data/sources/task_details_impl_remote_data_source.dart`
- **Tables Accessed**: task_supplies, task_objectives, tasks
- **Methods**: getTaskDetails, unsubscribe
- **Cache Usage**: Yes (LocalAppStorage)
### TasksImplRemoteDataSource
- **Path**: `volunteer/tasks/data/sources/tasks_impl_remote_data_source.dart`
- **Tables Accessed**: task_assignments
- **Methods**: getTasksStats
- **Cache Usage**: Yes (LocalAppStorage)
### VolunteerImplHomeRemoteDataSource
- **Path**: `volunteer/home/data/sources/volunteer_impl_home_remote_data_source.dart`
- **Tables Accessed**: users, task_assignments
- **Methods**: getVolunteerStats
- **Cache Usage**: Yes (LocalAppStorage)

## 8. Entity & Model Catalogue
### `AdminHomeState`
- **File**: `admin/home/presentation/cubit/admin_home_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class AdminHomeState with _, const factory AdminHomeState, const factory AdminHomeState, const factory AdminHomeState, AdminHomeDataEntity data, const factory AdminHomeState, String message, const factory AdminHomeState, const factory AdminHomeState
### `AdminReportsState`
- **File**: `admin/reports/presentation/cubit/admin_reports_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class AdminReportsState with _, const factory AdminReportsState, const factory AdminReportsState, const factory AdminReportsState, List<AdminReportEntity> reports, String filter, const factory AdminReportsState, String message, const factory AdminReportsState
### `AuthState`
- **File**: `auth/presentation/cubit/auth_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
abstract class AuthState with _, const factory AuthState, const factory AuthState, const factory AuthState, UserEntity user, const factory AuthState, const factory AuthState, String message, const factory AuthState
### `ChatbotState`
- **File**: `volunteer/bot/presentation/cubit/chatbot_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class ChatbotState with _, const factory ChatbotState, const factory ChatbotState, required List<ChatMessage> messages
### `HomeState`
- **File**: `volunteer/home/representation/cubit/home_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class HomeState with _, const factory HomeState, const factory HomeState, const factory HomeState, required VolunteerStatsEntity stats, required List<TaskEntity> todayTasks, required int unreadCount, const factory HomeState, String message
### `NavigationState`
- **File**: `app/cubit/navigation_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class NavigationState with _, const factory NavigationState, const factory NavigationState, required int currentIndex, required int previousIndex
### `PerformanceState`
- **File**: `volunteer/performance/presentation/cubit/performance_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class PerformanceState with _, const factory PerformanceState, const factory PerformanceState, const factory PerformanceState, required PerformanceStatsEntity stats, required List<MonthlyHoursEntity> monthlyHours, required List<LeaderboardEntryEntity> leaderboard, required String currentUserId, const factory PerformanceState
### `PerformanceStatsModel`
- **File**: `volunteer/performance/data/models/performance_models.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class PerformanceStatsModel with _, const factory PerformanceStatsModel, required String name, String avatarUrl, double rating, int level, String levelTitle, int totalHours, int placesVisited
### `ProfileModel`
- **File**: `volunteer/profile/data/model/profile_model.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class ProfileModel with _, const factory ProfileModel, required String id, required String name, required String email, String phone, String avatarUrl, String region, String qualification
### `ProfileState`
- **File**: `volunteer/profile/presentation/cubit/profile_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class ProfileState with _, const factory ProfileState, const factory ProfileState, const factory ProfileState, ProfileEntity profile, const factory ProfileState, String message
### `SplashState`
- **File**: `splash/cubit/splash_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class SplashState with _, const factory SplashState, const factory SplashState, required String route
### `TaskDetailsModel`
- **File**: `volunteer/task_details/data/models/task_details_model.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class TaskDetailsModel with _, const factory TaskDetailsModel, required String id, required String title, required String type, String? description, required String status, required String date, required String timeStart
### `TaskDetailsState`
- **File**: `volunteer/task_details/presentation/cubit/task_details_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class TaskDetailsState with _, const factory TaskDetailsState, const factory TaskDetailsState, const factory TaskDetailsState, TaskDetailsEntity task,  TaskDetailsStateLoaded, const factory TaskDetailsState, String message
### `TaskModel`
- **File**: `volunteer/tasks/data/models/task_models.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class TaskModel with _, const factory TaskModel, required String id, required String title, required String type, String description, required String status, required String date, required String timeStart
### `TaskObjectiveModel`
- **File**: `volunteer/task_details/data/models/task_objective_model.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class TaskObjectiveModel with _, const factory TaskObjectiveModel, required String id, required String taskId, required String title, int orderIndex, factory TaskObjectiveModel, dynamic> json, > _
### `TaskSupplyModel`
- **File**: `volunteer/task_details/data/models/task_supply_model.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class TaskSupplyModel with _, const factory TaskSupplyModel, required String id, required String taskId, required String name, int quantity, factory TaskSupplyModel, dynamic> json, > _
### `TasksState`
- **File**: `volunteer/tasks/presentation/cubit/tasks_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**:  part, freezed
abstract class TasksState with _, const factory TasksState, const factory TasksState, const factory TasksState, required List<TaskEntity> todayTasks, required List<TaskEntity> completedTasks, required TasksStatsEntity stats, int selectedTab, const factory TasksState
### `UserModel`
- **File**: `auth/data/models/user_model.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class UserModel with _, const factory UserModel, required String id, required String email, required String name, required String role, factory UserModel, dynamic> json, > _
### `VolunteerStatsModel`
- **File**: `volunteer/models/volunteer_stats_model.dart`
- **copyWith**: True
- **fromJson/toJson**: True
- **Fields**:  part, freezed
abstract class VolunteerStatsModel with _, const factory VolunteerStatsModel, required String id, required String name, required String email, String phone, String role, String gender, String avatarUrl
### `VolunteersState`
- **File**: `admin/volunteers/presentation/cubit/volunteers_state.dart`
- **copyWith**: True
- **fromJson/toJson**: False
- **Fields**: part of, freezed
class VolunteersState with _, const factory VolunteersState, const factory VolunteersState, const factory VolunteersState, List<AdminVolunteerEntity> volunteers, String filter, String searchQuery, List<AdminVolunteerEntity> pendingUsers, bool pendingLoading

## 9. Navigation Flow — Push/Pop Map
| Source File | Action | Destination Route / Path |
|---|---|---|
| `splash/presentation/splash_view.dart` | `go()` | `view` |
| `auth/presentation/view/login_view.dart` | `go()` | `Routes.adminHome` |
| `auth/presentation/view/login_view.dart` | `go()` | `Routes.volunteerHome` |
| `auth/presentation/view/login_view.dart` | `go()` | `Routes.register` |
| `auth/presentation/view/register_view.dart` | `go()` | `Routes.login` |
| `admin/home/presentation/view/admin_home_view.dart` | `go()` | `Routes.campaigns` |
| `admin/home/presentation/view/widgets/admin_app_bar.dart` | `push()` | `Routes.adminProfile` |
| `admin/profile/presentation/view/admin_profile_view.dart` | `go()` | `Routes.login` |
| `admin/volunteers/presentation/view/widgets/volunteer_card.dart` | `push()` | `/volunteerDetails/${volunteer.id}` |
| `volunteer/home/representation/volunteer_home_view.dart` | `go()` | `Routes.login` |
| `volunteer/home/representation/volunteer_home_view.dart` | `push()` | `Routes.volunteerProfile` |
| `volunteer/profile/presentation/view/volunteer_profile_view.dart` | `go()` | `Routes.login` |
| `onBoarding/presentation/first_onboarding.dart` | `go()` | `Routes.login` |

## 10. Widget Library
| Widget Name | File Path | Parameters / Description |
|---|---|---|
| `ActionCard` | `admin/campaigns/presentation/view/widgets/action_card.dart` | `titleColor, icon, title, subtitle, onTap` |
| `ActionsTab` | `admin/campaigns/presentation/view/widgets/actions_tab.dart` | `detail` |
| `AddItemHeader` | `admin/campaigns/presentation/view/widgets/add_item_header.dart` | `label, onAdd` |
| `AddVolunteerSheet` | `admin/volunteers/presentation/view/widgets/add_volunteer_sheet.dart` | `No exposed params` |
| `AddVolunteerSheet` | `admin/campaigns/presentation/view/widgets/add_volunteer_sheet.dart` | `taskId, volunteers` |
| `AdminAppBar` | `admin/home/presentation/view/widgets/admin_app_bar.dart` | `adminName, avatarUrl` |
| `AdminEditSheet` | `admin/profile/presentation/view/widgets/admin_edit_sheet.dart` | `phoneCtrl, userId, nameCtrl, emailCtrl` |
| `AdminNotificationCard` | `admin/notifications/presentation/view/widgets/admin_notification_card.dart` | `timeAgo, notification, onTap` |
| `AdminReportCard` | `admin/reports/presentation/view/widgets/admin_report_card.dart` | `report, onTap` |
| `AdminReviewSheet` | `admin/reports/presentation/view/widgets/admin_review_sheet.dart` | `report` |
| `AlertField` | `admin/campaigns/presentation/view/widgets/alert_field.dart` | `maxLines, hint, controller` |
| `AppFormField` | `base/widgets/app_form_field.dart` | `fillColor, label, hint, focusedBorderColor, maxLines, keyboardType, borderColor, textColor, hintColor, validator, prefixIcon, onChanged, controller` |
| `ApproveButton` | `admin/volunteers/presentation/view/widgets/approve_button.dart` | `volunteerId` |
| `AssignTaskSheet` | `admin/volunteers/presentation/view/widgets/assign_task_sheet.dart` | `task, label, onTap, selected` |
| `BadgeChip` | `admin/campaigns/presentation/view/widgets/badge_chip.dart` | `label` |
| `BarColumn` | `volunteer/performance/presentation/view/widgets/bar_column.dart` | `barWidth, label, ratio, hours` |
| `BotInfoRow` | `volunteer/bot/presentation/view/widgets/bot_info_row.dart` | `No exposed params` |
| `CampaignCard` | `admin/home/presentation/view/widgets/campaign_card.dart` | `campaign, onTap` |
| `CampaignCompletionCard` | `admin/performance/presentation/view/widgets/campaign_completion_card.dart` | `selectedPeriod, data, progress` |
| `CampaignFilterChips` | `admin/campaigns/presentation/view/widgets/campaign_filter_chips.dart` | `counts, onSelect, selected` |
| `CampaignFormBody` | `admin/campaigns/presentation/view/widgets/campaign_form_body.dart` | `locationAddressCtrl, volunteers, titleCtrl, onPickCombinedTime, onAddSupply, onRemoveSupply, selectedDate, supervisorNameCtrl, onRemoveObjective, notesCtrl, supplyNameCtrls, supplyQtyCtrls, locationNameCtrl, onPickDate, timeEnd, descCtrl, selectedType, objectiveCtrls, supervisorPhoneCtrl, onAddObjective, selectedStatus, targetCtrl, selectedIds, pointsCtrl, timeStart` |
| `CampaignHeroCard` | `admin/campaigns/presentation/view/widgets/campaign_hero_card.dart` | `detail` |
| `CampaignListCard` | `admin/campaigns/presentation/view/widgets/campaign_list_card.dart` | `campaign, onTap` |
| `CampaignReportSheet` | `admin/campaigns/presentation/view/widgets/campaign_report_sheet.dart` | `label, iconAsset, value, detail` |
| `CampaignStatBox` | `admin/campaigns/presentation/view/widgets/campaign_stat_box.dart` | `label, value` |
| `CampaignStatusChips` | `admin/campaigns/presentation/view/widgets/campaign_status_chips.dart` | `selectedStatus` |
| `ChatBubble` | `volunteer/bot/presentation/view/widgets/chat_bubble.dart` | `message, onChipTap` |
| `ChatInputBar` | `volunteer/bot/presentation/view/widgets/chat_input_bar.dart` | `onSend, controller` |
| `ChatMessageList` | `volunteer/bot/presentation/view/widgets/chat_message_list.dart` | `scrollController, messages, onChipTap` |
| `ChatbotHeader` | `volunteer/bot/presentation/view/widgets/chatbot_header.dart` | `No exposed params` |
| `ChipBadge` | `base/widgets/chip_badge.dart` | `color, fillColor, trailing, borderColor, icon, text` |
| `CreateVolunteerPickerSheet` | `admin/campaigns/presentation/view/widgets/create_volunteer_picker_sheet.dart` | `alreadySelected, onConfirm, volunteers` |
| `CustomShimmerWrapW` | `base/shimmers.dart` | `direction, height, circler, borderRadius, itemCount, padding, spacing, runSpacing, width` |
| `DeleteButton` | `admin/volunteers/presentation/view/widgets/delete_button.dart` | `volunteerId` |
| `DescriptionSection` | `volunteer/task_details/presentation/view/widgets/description_section.dart` | `description` |
| `DropdownField` | `admin/campaigns/presentation/view/widgets/dropdown_field.dart` | `itemLabel, items, label, value, onChanged` |
| `EditRatingSheet` | `admin/volunteers/presentation/view/widgets/edit_rating_sheet.dart` | `currentRating` |
| `EditVolunteerDataSheet` | `admin/volunteers/presentation/view/widgets/edit_volunteer_data_sheet.dart` | `details` |
| `EmptyStateText` | `base/widgets/empty_state_text.dart` | `message` |
| `ErrorState` | `base/widgets/error_state.dart` | `onRetry, message` |
| `ExistingReportView` | `volunteer/task_details/presentation/view/widgets/existing_report_view.dart` | `report` |
| `FilterChipItem` | `base/widgets/filter_chip_item.dart` | `border, horizontalPadding, label, selected, borderRadius, unselectedColor, onTap, selectedColor` |
| `FormFieldLabel` | `admin/campaigns/presentation/view/widgets/form_field_label.dart` | `text` |
| `FormFieldWidget` | `volunteer/task_details/presentation/view/widgets/form_field_widget.dart` | `label, inputFormatters, hint, maxLines, keyboardType, validator, controller` |
| `GenderDropDown` | `auth/presentation/view/widgets/gender_drop_down.dart` | `gender` |
| `GradientCard` | `volunteer/task_details/presentation/view/widgets/gradient_card.dart` | `child` |
| `GreetingCard` | `volunteer/home/representation/view/widgets/greeting_card.dart` | `name, level, levelTitle` |
| `HomeActionCard` | `admin/home/presentation/view/widgets/home_action_card.dart` | `label, icon, onTap` |
| `HomeAppBar` | `volunteer/home/representation/view/widgets/home_app_bar.dart` | `onProfileTap` |
| `HomeStatCard` | `volunteer/home/representation/view/widgets/home_stat_card.dart` | `label, value` |
| `HonorBoard` | `volunteer/performance/presentation/view/widgets/honor_board.dart` | `leaderboard, currentUserId` |
| `HotspotCard` | `volunteer/maps/widgets/hotspot_card.dart` | `name, cases, severity` |
| `InfoRow` | `base/widgets/info_row.dart` | `label, valueColor, value, icon, labelColor` |
| `LeaderRow` | `volunteer/performance/presentation/view/widgets/leader_row.dart` | `isMe, pts, name, medal, hours` |
| `LoadingIndicator` | `base/widgets/loading_indicator.dart` | `No exposed params` |
| `LocationSection` | `volunteer/task_details/presentation/view/widgets/location_section.dart` | `task` |
| `MapButton` | `volunteer/task_details/presentation/view/widgets/map_button.dart` | `lng, lat` |
| `MapSection` | `volunteer/maps/widgets/map_section.dart` | `center` |
| `MonthlyChart` | `volunteer/performance/presentation/view/widgets/monthly_chart.dart` | `monthlyHours` |
| `NavBarItem` | `base/widgets/nav_bar_item.dart` | `label, onTap, isSelected, iconPath` |
| `NotesCard` | `volunteer/task_details/presentation/view/widgets/notes_card.dart` | `notes` |
| `NotificationBubble` | `volunteer/notifications/presentation/view/widgets/notification_bubble.dart` | `timeAgo, notification, onTap` |
| `NotificationsEmptyState` | `volunteer/notifications/presentation/view/widgets/notifications_empty_state.dart` | `No exposed params` |
| `NotificationsErrorState` | `volunteer/notifications/presentation/view/widgets/notifications_error_state.dart` | `state` |
| `ObjectiveField` | `admin/campaigns/presentation/view/widgets/objective_field.dart` | `onRemove, index, controller` |
| `ObjectivesSection` | `volunteer/task_details/presentation/view/widgets/objectives_section.dart` | `objectives` |
| `OverviewDivider` | `admin/campaigns/presentation/view/widgets/overview_divider.dart` | `No exposed params` |
| `OverviewInfoCard` | `admin/campaigns/presentation/view/widgets/overview_info_card.dart` | `children` |
| `OverviewInfoRowWithCheck` | `admin/campaigns/presentation/view/widgets/overview_info_row_with_check.dart` | `label, icon, achieved, value` |
| `OverviewListCard` | `admin/campaigns/presentation/view/widgets/overview_list_card.dart` | `items, icon, title` |
| `OverviewSectionCard` | `admin/campaigns/presentation/view/widgets/overview_section_card.dart` | `body, title` |
| `OverviewTab` | `admin/campaigns/presentation/view/widgets/overview_tab.dart` | `detail` |
| `PerfStatBox` | `base/widgets/perf_stat_box.dart` | `iconAsset, value, decoration, label` |
| `PerformanceBarChart` | `admin/performance/presentation/view/widgets/performance_bar_chart.dart` | `bars, title` |
| `PerformanceStatsRow` | `admin/performance/presentation/view/widgets/performance_stats_row.dart` | `data` |
| `PerformanceStatsRow` | `volunteer/performance/presentation/view/widgets/performance_stats_row.dart` | `stats` |
| `PerformanceTimeFilter` | `admin/performance/presentation/view/widgets/performance_time_filter.dart` | `No exposed params` |
| `PrimaryElevatedButton` | `base/primary_widgets.dart` | `filledColor, height, groupValue, borderColor, onChanged, titleWidget, validator, prefixIcon, controller, isLoading, label, textAlign, iconColor, onPress, isPassword, textStyle, image, groub, keyboardType, icon, title, color, buttonRadius, iconSize, value, hasPopUp, hint, readOnly, iconPath, maxLines, size, onTap, backGroundColor, child, bgColor, width` |
| `PrimaryScaffold` | `base/components.dart` | `appBar, body, backgroundColor, navigationShell, drawer, showBannerAd` |
| `PrimaryTabBar` | `base/widgets/primary_tab_bar.dart` | `labels, controller` |
| `ProfileAppBar` | `volunteer/profile/presentation/view/widgets/profile_app_bar.dart` | `No exposed params` |
| `ProfileBadge` | `base/widgets/profile_badge.dart` | `label, color, borderColor` |
| `ProfileHeaderCard` | `base/widgets/profile_header_card.dart` | `badges, name, subtitle, avatarUrl` |
| `ProfileInfoSection` | `base/widgets/profile_info_section.dart` | `items, label, hasDivider, value` |
| `ProfileLogoutButton` | `volunteer/profile/presentation/view/widgets/profile_logout_button.dart` | `onPress` |
| `QualificationRow` | `admin/volunteers/presentation/view/widgets/qualification_row.dart` | `values` |
| `QuickActionChips` | `volunteer/bot/presentation/view/widgets/quick_actions_chips.dart` | `actions, onTap` |
| `QuickActionsSection` | `admin/home/presentation/view/widgets/quick_actions_section.dart` | `onNewCampaign, onSendAnnouncement, onFullReport` |
| `RatingCard` | `volunteer/performance/presentation/view/widgets/rating_card.dart` | `stats` |
| `ReadonlyField` | `base/widgets/readonly_field.dart` | `label, value, iconColor, borderColor, icon, textColor, backgroundColor` |
| `RegionItem` | `admin/performance/presentation/view/widgets/region_item.dart` | `fraction, count, rank, region` |
| `RegionRankingSection` | `admin/performance/presentation/view/widgets/region_ranking_section.dart` | `regions` |
| `ReportButton` | `volunteer/task_details/presentation/view/widgets/report_button.dart` | `taskTitle, taskId` |
| `ReportDivider` | `admin/campaigns/presentation/view/widgets/report_divider.dart` | `No exposed params` |
| `ReportForm` | `volunteer/task_details/presentation/view/widgets/report_form.dart` | `rating, materialsCtrl, isSubmitting, onCancel, summaryCtrl, onSubmit, challengesCtrl, attendeesCtrl, notesCtrl, onRatingChanged, formKey` |
| `ReportFormHeader` | `volunteer/task_details/presentation/view/widgets/report_form_header.dart` | `title, onClose` |
| `ReportInfoRow` | `admin/campaigns/presentation/view/widgets/report_info_row.dart` | `label, valueColor, iconColor, value, icon` |
| `ReportLabeledField` | `volunteer/task_details/presentation/view/widgets/report_labeled_field.dart` | `label, hint, maxLines, keyboardType, validator, controller` |
| `ReportStarRating` | `volunteer/task_details/presentation/view/widgets/report_star_rating.dart` | `onRatingChanged, rating` |
| `ReportSubmitButton` | `volunteer/task_details/presentation/view/widgets/report_submit_button.dart` | `onPressed, isSubmitting, label` |
| `ReviewDetailCard` | `admin/reports/presentation/view/widgets/review_detail_card.dart` | `titleColor, title, content` |
| `ReviewInfoRow` | `admin/reports/presentation/view/widgets/review_info_row.dart` | `valueColor, label, value` |
| `RoleSwitcher` | `auth/presentation/view/widgets/role_switcher.dart` | `isSelected, label, isVolunteer, icon, onTap` |
| `SectionHeader` | `volunteer/task_details/presentation/view/widgets/section_header.dart` | `icon, title` |
| `SectionLabel` | `base/widgets/section_label.dart` | `label` |
| `SendAlertSheet` | `admin/campaigns/presentation/view/widgets/send_alert_sheet.dart` | `detail` |
| `SendAnnouncementSheet` | `admin/home/presentation/view/widgets/send_announcement_sheet.dart` | `No exposed params` |
| `SendMessageSheet` | `admin/volunteers/presentation/view/widgets/send_message_sheet.dart` | `No exposed params` |
| `StatCard` | `admin/home/presentation/view/widgets/stat_card.dart` | `trend, label, value, iconBgColor, icon` |
| `StatsGrid` | `admin/home/presentation/view/widgets/stats_grid.dart` | `totalVolunteers, activeTodayCount, activeDiffFromYesterday, completedCampaigns, volunteersThisMonth, hoursPercentChange, totalHours` |
| `StatsGrid` | `volunteer/home/representation/view/widgets/stats_grid.dart` | `rating, totalPoints, placesVisited, totalTasks, totalHours` |
| `StatusBadge` | `base/widgets/status_badge.dart` | `status` |
| `StatusBanner` | `admin/home/presentation/view/widgets/status_banner.dart` | `activeVolunteersCount` |
| `SubmitReportSheet` | `volunteer/task_details/presentation/view/widgets/submit_report_sheet.dart` | `taskTitle, taskId` |
| `SupervisorSection` | `volunteer/task_details/presentation/view/widgets/supervisor_section.dart` | `name, phone` |
| `SuppliesCard` | `volunteer/task_details/presentation/view/widgets/supplies_card.dart` | `supplies` |
| `SuppliesNoteCard` | `volunteer/task_details/presentation/view/widgets/supplies_note_card.dart` | `No exposed params` |
| `SupplyField` | `admin/campaigns/presentation/view/widgets/supply_field.dart` | `index, nameController, quantityController, onRemove` |
| `SupplyRow` | `volunteer/task_details/presentation/view/widgets/supply_row.dart` | `supply` |
| `TabItem` | `volunteer/task_details/presentation/view/widgets/tab_item.dart` | `isFirst, isSelected, label, icon, onTap` |
| `TaskCard` | `volunteer/tasks/presentation/view/widgets/tasks_card.dart` | `task, onTap` |
| `TaskDetailsHeaderCard` | `volunteer/task_details/presentation/view/widgets/task_details_header_card.dart` | `task` |
| `TaskDetailsTab` | `volunteer/task_details/presentation/view/widgets/task_details_tab.dart` | `task` |
| `TaskDetailsTabSwitcher` | `volunteer/task_details/presentation/view/widgets/task_details_tab_switcher.dart` | `selectedIndex, onTabChanged` |
| `TaskErrorBody` | `volunteer/task_details/presentation/view/widgets/task_error_body.dart` | `onRetry, message` |
| `TaskInfoRow` | `volunteer/task_details/presentation/view/widgets/task_info_row.dart` | `label, color, icon, borderColor` |
| `TaskSuppliesTab` | `volunteer/task_details/presentation/view/widgets/task_supplies_tab.dart` | `task` |
| `TaskTypeBadge` | `volunteer/task_details/presentation/view/widgets/task_type_badge.dart` | `type` |
| `TasksHeaderStats` | `volunteer/tasks/presentation/view/widgets/tasks_header_states.dart` | `stats` |
| `TasksTabSwitcher` | `volunteer/tasks/presentation/view/widgets/tasks_tab_switcher.dart` | `todayCount, selectedIndex, completedCount, onTabChanged` |
| `TeamMemberCard` | `admin/campaigns/presentation/view/widgets/team_member_card.dart` | `onLongPress, member` |
| `TeamTab` | `admin/campaigns/presentation/view/widgets/team_tab.dart` | `detail` |
| `TodayCampaignsSection` | `admin/home/presentation/view/widgets/today_campaigns_section.dart` | `onViewAll, onCampaignTap, campaigns` |
| `TodayTaskCard` | `volunteer/home/representation/view/widgets/today_task_card.dart` | `task, onTap` |
| `TodayTasksSection` | `volunteer/home/representation/view/widgets/todays_task_section.dart` | `onTaskTap, onViewAll, tasks` |
| `UpgradeLevelSheet` | `admin/volunteers/presentation/view/widgets/upgrade_level_sheet.dart` | `details` |
| `VolunteerActionRow` | `admin/volunteers/presentation/view/widgets/volunteer_action_row.dart` | `label, icon, onTap` |
| `VolunteerBadge` | `admin/volunteers/presentation/view/widgets/volunteer_badge.dart` | `label, color, icon, bg` |
| `VolunteerCard` | `admin/volunteers/presentation/view/widgets/volunteer_card.dart` | `volunteer, onTap` |
| `VolunteerDataTab` | `admin/volunteers/presentation/view/widgets/volunteer_data_tab.dart` | `details` |
| `VolunteerDetailStatBox` | `admin/volunteers/presentation/view/widgets/volunteer_detail_stat_box.dart` | `label, icon, value` |
| `VolunteerDetailsHeader` | `admin/volunteers/presentation/view/widgets/volunteer_details_header.dart` | `details` |
| `VolunteerFilterChips` | `admin/volunteers/presentation/view/widgets/volunteer_filter_chips.dart` | `selectedFilter, volunteers` |
| `VolunteerManageTab` | `admin/volunteers/presentation/view/widgets/volunteer_manage_tab.dart` | `name, volunteerId, details` |
| `VolunteerPickerRow` | `admin/campaigns/presentation/view/widgets/volunteer_picker_row.dart` | `isSelected, volunteer` |
| `VolunteerSearchBar` | `admin/volunteers/presentation/view/widgets/volunteer_search_bar.dart` | `No exposed params` |
| `VolunteerSelectionCard` | `admin/campaigns/presentation/view/widgets/volunteer_selection_card.dart` | `isSelected, volunteer, onTap` |
| `VolunteerSelectionList` | `admin/campaigns/presentation/view/widgets/volunteer_selection_list.dart` | `selectedVolunteers, volunteers, onRemove, selectedIds, onAddPressed, onToggle, volunteer` |
| `VolunteerStatsBox` | `admin/volunteers/presentation/view/widgets/volunteer_stats_box.dart` | `label, color, value` |
| `VolunteerTaskCard` | `admin/volunteers/presentation/view/widgets/volunteer_task_card.dart` | `task` |
| `VolunteerTasksTab` | `admin/volunteers/presentation/view/widgets/volunteer_tasks_tab.dart` | `details` |
| `_AppToastWidget` | `base/widgets/app_toast.dart` | `duration, onDismiss, message, type` |

## 11. Color & Design Tokens

## 12. Known Issues & Intentional Spellings
- AuthRemoteDateSource in app/di.dart
- AuthRemoteDateSource in auth/data/repository/auth_impl_repository.dart
- AuthRemoteDateSource in auth/data/source/auth_impl_remote_data_source.dart
- AuthRemoteDateSource in auth/data/source/auth_remote_date_source.dart
- Failture correctly misspelled in admin/campaigns/data/datasources/campaigns_remote_datasource_impl.dart
- Failture correctly misspelled in admin/campaigns/data/repos/campaigns_repo_impl.dart
- Failture correctly misspelled in admin/campaigns/domain/repos/campaigns_repo.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/assign_volunteer_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/create_campaign_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/delete_campaign_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/get_all_volunteers_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/get_campaign_detail_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/get_campaign_stats_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/get_campaigns_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/get_unassigned_volunteers_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/remove_volunteer_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/send_team_alert_usecase.dart
- Failture correctly misspelled in admin/campaigns/domain/usecases/update_campaign_usecase.dart
- Failture correctly misspelled in admin/home/data/repos/admin_home_repo_impl.dart
- Failture correctly misspelled in admin/home/domain/repos/admin_home_repo.dart
- Failture correctly misspelled in admin/home/domain/usecases/get_admin_home_data_usecase.dart
- Failture correctly misspelled in admin/home/domain/usecases/send_announcement_usecase.dart
- Failture correctly misspelled in admin/notifications/data/repository/admin_notifications_impl_repository.dart
- Failture correctly misspelled in admin/notifications/domain/repository/admin_notifications_repository.dart
- Failture correctly misspelled in admin/notifications/domain/use_cases/get_admin_notifications_use_case.dart
- Failture correctly misspelled in admin/notifications/domain/use_cases/mark_admin_notification_read_use_case.dart
- Failture correctly misspelled in admin/notifications/domain/use_cases/mark_all_admin_notifications_read_use_case.dart
- Failture correctly misspelled in admin/performance/data/repos/admin_performance_repo_impl.dart
- Failture correctly misspelled in admin/performance/domain/repos/admin_performance_repo.dart
- Failture correctly misspelled in admin/performance/domain/usecases/get_admin_performance_usecase.dart
- Failture correctly misspelled in admin/profile/data/repos/admin_profile_repo_impl.dart
- Failture correctly misspelled in admin/profile/domain/repos/admin_profile_repo.dart
- Failture correctly misspelled in admin/profile/domain/usecases/get_admin_profile_usecase.dart
- Failture correctly misspelled in admin/profile/domain/usecases/update_admin_profile_usecase.dart
- Failture correctly misspelled in admin/reports/data/repos/admin_reports_repo_impl.dart
- Failture correctly misspelled in admin/reports/domain/repos/admin_reports_repo.dart
- Failture correctly misspelled in admin/reports/domain/usecases/get_reports_usecase.dart
- Failture correctly misspelled in admin/reports/domain/usecases/review_report_usecase.dart
- Failture correctly misspelled in admin/volunteers/data/repos/volunteers_repo_impl.dart
- Failture correctly misspelled in admin/volunteers/domain/repos/volunteers_repo.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/add_rating_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/add_volunteer_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/approve_volunteer_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/assign_custom_task_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/assign_task_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/delete_volunteer_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/edit_volunteer_data_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/get_available_tasks_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/get_pending_users_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/get_volunteer_details_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/get_volunteers_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/send_direct_message_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/suspend_account_usecase.dart
- Failture correctly misspelled in admin/volunteers/domain/usecases/upgrade_level_usecase.dart
- Failture correctly misspelled in app/error_handler.dart
- Failture correctly misspelled in app/failture.dart
- Failture correctly misspelled in auth/data/repository/auth_impl_repository.dart
- Failture correctly misspelled in auth/data/source/auth_impl_remote_data_source.dart
- Failture correctly misspelled in auth/domain/repository/auth_repository.dart
- Failture correctly misspelled in auth/domain/use_cases/login_use_case.dart
- Failture correctly misspelled in auth/domain/use_cases/register_use_case.dart
- Failture correctly misspelled in volunteer/home/data/repository/volunteer_impl_home_repository.dart
- Failture correctly misspelled in volunteer/home/domain/repository/home_repository.dart
- Failture correctly misspelled in volunteer/home/domain/use_case/home_use_case.dart
- Failture correctly misspelled in volunteer/notifications/data/repository/notifications_impl_repository.dart
- Failture correctly misspelled in volunteer/notifications/domain/repository/notifications_repository.dart
- Failture correctly misspelled in volunteer/notifications/domain/use_cases/get_notifications_use_case.dart
- Failture correctly misspelled in volunteer/notifications/domain/use_cases/mark_all_as_read_use_case.dart
- Failture correctly misspelled in volunteer/notifications/domain/use_cases/mark_as_read_use_case.dart
- Failture correctly misspelled in volunteer/performance/data/repository/performance_impl_repository.dart
- Failture correctly misspelled in volunteer/performance/domain/repository/performance_repository.dart
- Failture correctly misspelled in volunteer/performance/domain/use_cases/performance_use_cases.dart
- Failture correctly misspelled in volunteer/profile/data/repository/profile_impl_remote_data_source.dart
- Failture correctly misspelled in volunteer/profile/domain/repository/profile_repository.dart
- Failture correctly misspelled in volunteer/profile/domain/use_cases/profile_use_case.dart
- Failture correctly misspelled in volunteer/task_details/data/repository/report_impl_repository.dart
- Failture correctly misspelled in volunteer/task_details/data/repository/task_details_impl_repository.dart
- Failture correctly misspelled in volunteer/task_details/domain/repository/report_repository.dart
- Failture correctly misspelled in volunteer/task_details/domain/repository/task_details_repository.dart
- Failture correctly misspelled in volunteer/task_details/domain/use_cases/get_existing_report_use_case.dart
- Failture correctly misspelled in volunteer/task_details/domain/use_cases/get_task_details_use_case.dart
- Failture correctly misspelled in volunteer/task_details/domain/use_cases/submit_report_use_case.dart
- Failture correctly misspelled in volunteer/tasks/data/repository/tasks_impl_repository.dart
- Failture correctly misspelled in volunteer/tasks/domain/repository/tasks_repository.dart
- Failture correctly misspelled in volunteer/tasks/domain/use_cases/get_completed_tasks.dart
- Failture correctly misspelled in volunteer/tasks/domain/use_cases/get_tasks_stats.dart
- Failture correctly misspelled in volunteer/tasks/domain/use_cases/get_today_tasks.dart
- extensions spelling in admin/campaigns/presentation/view/campaign_detail_view.dart
- extensions spelling in admin/campaigns/presentation/view/create_campaign_view.dart
- extensions spelling in admin/campaigns/presentation/view/widgets/add_volunteer_sheet.dart
- extensions spelling in admin/home/presentation/view/widgets/send_announcement_sheet.dart
- extensions spelling in admin/reports/presentation/view/widgets/admin_review_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/volunteer_details_view.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/add_volunteer_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/assign_task_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/edit_rating_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/edit_volunteer_data_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/send_message_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/upgrade_level_sheet.dart
- extensions spelling in admin/volunteers/presentation/view/widgets/volunteer_manage_tab.dart
- extensions spelling in app/extenstions.dart
- extensions spelling in app/resources/extenstions.dart
- extensions spelling in auth/presentation/view/login_view.dart
- extensions spelling in auth/presentation/view/register_view.dart
- extensions spelling in volunteer/task_details/presentation/view/widgets/submit_report_sheet.dart
- representation instead of presentation in app/di.dart
- representation instead of presentation in app/resources/routes.dart
- representation instead of presentation in volunteer/home/representation/view/widgets/todays_task_section.dart
- representation instead of presentation in volunteer/home/representation/volunteer_home_view.dart

## 13. Cross-Side Data Flow
| Admin Action | Tables Modified | Volunteer Cubits Affected | How Volunteer Detects Change |
|---|---|---|---|
| Manage Campaigns | `campaigns` | `CampaignsCubit`, `HomeCubit` | Stream Subscriptions, API Refetch |
| Assign Task | `tasks` | `TasksCubit`, `HomeCubit` | Realtime on `tasks` table, Cache invalidation |
| Approve Volunteer | `volunteers` | `AuthCubit` | Session Check |
| Notification Send | `notifications` | `NotificationsCubit` | Realtime Sub |

## 14. Cache Strategy (LocalAppStorage)
| Cache Key / Prefix | File Origin | Used for |
|---|---|---|
| `admin_profile_$userId` | Derived from usage | State persistence |
| `admin_volunteers` | Derived from usage | State persistence |
| `campaigns_list` | Derived from usage | State persistence |
| `campaigns_stats` | Derived from usage | State persistence |
| `completed_tasks_$userId` | Derived from usage | State persistence |
| `tasks_stats_$userId` | Derived from usage | State persistence |
| `vol_stats_v2_$userId` | Derived from usage | State persistence |