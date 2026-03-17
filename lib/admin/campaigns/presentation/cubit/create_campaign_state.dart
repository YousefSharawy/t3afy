part of 'create_campaign_cubit.dart';

abstract class CreateCampaignState {
  const CreateCampaignState();
}

class CreateCampaignInitial extends CreateCampaignState {
  const CreateCampaignInitial();
}

class CreateCampaignLoading extends CreateCampaignState {
  const CreateCampaignLoading();
}

/// Volunteers loaded and form is ready. [taskData] is non-null only in edit mode
/// and is used to prefill controllers once via BlocListener.
class CreateCampaignReady extends CreateCampaignState {
  final List<VolunteerEntity> volunteers;
  final Set<String> selectedIds;
  final Map<String, dynamic>? taskData;

  const CreateCampaignReady({
    required this.volunteers,
    required this.selectedIds,
    this.taskData,
  });
}

class CreateCampaignSaving extends CreateCampaignState {
  const CreateCampaignSaving();
}

class CreateCampaignSaved extends CreateCampaignState {
  const CreateCampaignSaved();
}

/// Emitted when a save action fails. UI shows a snackbar then the cubit
/// immediately re-emits [CreateCampaignReady] so the form remains usable.
class CreateCampaignActionError extends CreateCampaignState {
  final String message;
  const CreateCampaignActionError(this.message);
}

class CreateCampaignError extends CreateCampaignState {
  final String message;
  const CreateCampaignError(this.message);
}
