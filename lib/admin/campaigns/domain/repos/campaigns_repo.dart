import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../entities/campaign_entity.dart';
import '../entities/campaign_detail_entity.dart';
import '../entities/volunteer_entity.dart';

abstract class CampaignsRepo {
  void subscribeRealtime(void Function() onChanged);
  void disposeRealtime();
  Future<Either<Failture, List<CampaignEntity>>> getCampaigns();
  Future<Either<Failture, Map<String, int>>> getCampaignStats();
  Future<Either<Failture, CampaignDetailEntity>> getCampaignDetail(String id);
  Future<Either<Failture, String>> createCampaign(Map<String, dynamic> data);
  Future<Either<Failture, void>> updateCampaign(String id, Map<String, dynamic> data);
  Future<Either<Failture, void>> deleteCampaign(String id);
  Future<Either<Failture, void>> assignVolunteer({
    required String taskId,
    required String userId,
    required String adminId,
  });
  Future<Either<Failture, void>> removeVolunteer({
    required String taskId,
    required String userId,
  });
  Future<Either<Failture, void>> sendTeamAlert({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  });
  Future<Either<Failture, List<VolunteerEntity>>> getUnassignedVolunteers(String taskId);
  Future<Either<Failture, List<VolunteerEntity>>> getAllVolunteers();
}
