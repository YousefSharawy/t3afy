part of 'campaign_detail_cubit.dart';

abstract class CampaignDetailState {
  const CampaignDetailState();
}

class CampaignDetailInitial extends CampaignDetailState {
  const CampaignDetailInitial();
}

class CampaignDetailLoading extends CampaignDetailState {
  const CampaignDetailLoading();
}

class CampaignDetailLoaded extends CampaignDetailState {
  final CampaignDetailEntity detail;
  const CampaignDetailLoaded(this.detail);
}

class CampaignDetailError extends CampaignDetailState {
  final String message;
  const CampaignDetailError(this.message);
}

class CampaignDetailSaving extends CampaignDetailState {
  const CampaignDetailSaving();
}

class CampaignDetailAlertSent extends CampaignDetailState {
  const CampaignDetailAlertSent();
}

class CampaignDetailDeleted extends CampaignDetailState {
  const CampaignDetailDeleted();
}

class CampaignDetailActionError extends CampaignDetailState {
  final String message;
  const CampaignDetailActionError(this.message);
}
