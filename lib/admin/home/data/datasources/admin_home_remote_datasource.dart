import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';

abstract class AdminHomeRemoteDatasource {
  Future<AdminHomeDataEntity> getDashboardData(String adminId);
  Future<void> sendAnnouncement({
    required String title,
    required String body,
    required String adminId,
  });
}
