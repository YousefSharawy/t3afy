import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/admin/home/domain/repos/admin_home_repo.dart';

class GetAdminHomeDataUsecase {
  final AdminHomeRepo _repo;

  GetAdminHomeDataUsecase(this._repo);

  Future<Either<Failture, AdminHomeDataEntity>> call(String adminId) {
    return _repo.getDashboardData(adminId);
  }
}
