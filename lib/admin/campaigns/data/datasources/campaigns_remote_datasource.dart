import '../../domain/entities/campaign_entity.dart';
import '../../domain/entities/campaign_detail_entity.dart';
import '../../domain/entities/volunteer_entity.dart';

abstract class CampaignsRemoteDatasource {
  Future<List<CampaignEntity>> getCampaigns();
  Future<Map<String, int>> getCampaignStats();
  Future<CampaignDetailEntity> getCampaignDetail(String id);
  Future<String> createCampaign(Map<String, dynamic> data);
  Future<void> updateCampaign(String id, Map<String, dynamic> data);
  Future<void> deleteCampaign(String id);
  Future<void> assignVolunteer({
    required String taskId,
    required String userId,
    required String adminId,
  });
  Future<void> removeVolunteer({required String taskId, required String userId});
  Future<void> sendTeamAlert({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  });
  Future<List<VolunteerEntity>> getUnassignedVolunteers(String taskId);
}
