import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class DeleteCampaignUsecase {
  final CampaignsRepo _repo;
  DeleteCampaignUsecase(this._repo);

  Future<Either<Failture, void>> call(String id) => _repo.deleteCampaign(id);
}
