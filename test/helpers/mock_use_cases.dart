import 'package:mocktail/mocktail.dart';
import 'package:t3afy/auth/domain/use_cases/login_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/register_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/log_out_use_case.dart';
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
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteers_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteer_details_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_available_tasks_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/add_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/delete_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/approve_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_pending_users_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/assign_task_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/assign_custom_task_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/send_direct_message_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/add_rating_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/upgrade_level_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/edit_volunteer_data_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/suspend_account_usecase.dart';

// Auth
class MockLogin extends Mock implements Login {}
class MockRegister extends Mock implements Register {}
class MockLogout extends Mock implements Logout {}

// Campaign use cases
class MockGetCampaignsUsecase extends Mock implements GetCampaignsUsecase {}
class MockGetCampaignStatsUsecase extends Mock implements GetCampaignStatsUsecase {}
class MockGetCampaignDetailUsecase extends Mock implements GetCampaignDetailUsecase {}
class MockCreateCampaignUsecase extends Mock implements CreateCampaignUsecase {}
class MockUpdateCampaignUsecase extends Mock implements UpdateCampaignUsecase {}
class MockDeleteCampaignUsecase extends Mock implements DeleteCampaignUsecase {}
class MockAssignVolunteerUsecase extends Mock implements AssignVolunteerUsecase {}
class MockRemoveVolunteerUsecase extends Mock implements RemoveVolunteerUsecase {}
class MockSendTeamAlertUsecase extends Mock implements SendTeamAlertUsecase {}
class MockGetUnassignedVolunteersUsecase extends Mock implements GetUnassignedVolunteersUsecase {}
class MockGetAllVolunteersUsecase extends Mock implements GetAllVolunteersUsecase {}

// Volunteer use cases
class MockGetVolunteersUsecase extends Mock implements GetVolunteersUsecase {}
class MockGetAvailableTasksUsecase extends Mock implements GetAvailableTasksUsecase {}
class MockGetVolunteerDetailsUsecase extends Mock implements GetVolunteerDetailsUsecase {}
class MockAddVolunteerUsecase extends Mock implements AddVolunteerUsecase {}
class MockDeleteVolunteerUsecase extends Mock implements DeleteVolunteerUsecase {}
class MockApproveVolunteerUsecase extends Mock implements ApproveVolunteerUsecase {}
class MockGetPendingUsersUsecase extends Mock implements GetPendingUsersUsecase {}
class MockAssignTaskUsecase extends Mock implements AssignTaskUsecase {}
class MockAssignCustomTaskUsecase extends Mock implements AssignCustomTaskUsecase {}
class MockSendDirectMessageUsecase extends Mock implements SendDirectMessageUsecase {}
class MockAddRatingUsecase extends Mock implements AddRatingUsecase {}
class MockUpgradeLevelUsecase extends Mock implements UpgradeLevelUsecase {}
class MockEditVolunteerDataUsecase extends Mock implements EditVolunteerDataUsecase {}
class MockSuspendAccountUsecase extends Mock implements SuspendAccountUsecase {}
