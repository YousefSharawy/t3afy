import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';

abstract class AdminHomeRepo {
  Future<Either<Failture, AdminHomeDataEntity>> getDashboardData(
    String adminId,
  );
  Future<Either<Failture, void>> sendAnnouncement({
    required String title,
    required String body,
    required String adminId,
  });
  void subscribeRealtime(void Function() onChanged);
  void disposeRealtime();
}
