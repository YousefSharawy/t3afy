import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../repos/campaigns_repo.dart';

class GetCampaignStatsUsecase {
  final CampaignsRepo _repo;
  GetCampaignStatsUsecase(this._repo);

  Future<Either<Failture, Map<String, int>>> call() => _repo.getCampaignStats();
}
