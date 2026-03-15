import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/home/domain/repos/admin_home_repo.dart';

class SendAnnouncementUsecase {
  final AdminHomeRepo _repo;

  SendAnnouncementUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String title,
    required String body,
    required String adminId,
  }) {
    return _repo.sendAnnouncement(
      title: title,
      body: body,
      adminId: adminId,
    );
  }
}
