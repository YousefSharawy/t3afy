import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class CreateCampaignUsecase {
  final CampaignsRepo _repo;
  CreateCampaignUsecase(this._repo);

  Future<Either<Failture, String>> call(Map<String, dynamic> data) =>
      _repo.createCampaign(data);
}
