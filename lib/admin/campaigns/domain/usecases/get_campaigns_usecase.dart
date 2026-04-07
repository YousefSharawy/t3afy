import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../entities/campaign_entity.dart';
import '../repos/campaigns_repo.dart';

class GetCampaignsUsecase {
  final CampaignsRepo _repo;
  GetCampaignsUsecase(this._repo);

  Future<Either<Failture, List<CampaignEntity>>> call({bool skipCache = false}) =>
    _repo.getCampaigns(skipCache: skipCache);
}
