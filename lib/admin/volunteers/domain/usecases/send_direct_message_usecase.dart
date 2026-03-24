import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class SendDirectMessageUsecase {
  final VolunteersRepo _repo;

  SendDirectMessageUsecase(this._repo);

  Future<Either<Failture, void>> call({
    required String adminId,
    required String volunteerId,
    required String title,
    required String body,
  }) {
    return _repo.sendDirectMessage(
      adminId: adminId,
      volunteerId: volunteerId,
      title: title,
      body: body,
    );
  }
}
