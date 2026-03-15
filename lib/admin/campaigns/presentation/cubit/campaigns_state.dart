part of 'campaigns_cubit.dart';

abstract class CampaignsState {
  const CampaignsState();
}

class CampaignsInitial extends CampaignsState {
  const CampaignsInitial();
}

class CampaignsLoading extends CampaignsState {
  const CampaignsLoading();
}

class CampaignsLoaded extends CampaignsState {
  final List<CampaignEntity> campaigns;
  final String filter;
  final Map<String, int> stats;

  const CampaignsLoaded(this.campaigns, this.filter, this.stats);
}

class CampaignsError extends CampaignsState {
  final String message;

  const CampaignsError(this.message);
}
