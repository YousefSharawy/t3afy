import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import '../entities/campaign_detail_entity.dart';
import '../repos/campaigns_repo.dart';

class GetCampaignDetailUsecase {
  final CampaignsRepo _repo;
  GetCampaignDetailUsecase(this._repo);

  Future<Either<Failture, CampaignDetailEntity>> call(String id) =>
      _repo.getCampaignDetail(id);
}
