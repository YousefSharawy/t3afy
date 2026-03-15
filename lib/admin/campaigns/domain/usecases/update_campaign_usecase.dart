import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class UpdateCampaignUsecase {
  final CampaignsRepo _repo;
  UpdateCampaignUsecase(this._repo);

  Future<Either<Failture, void>> call(String id, Map<String, dynamic> data) =>
      _repo.updateCampaign(id, data);
}
