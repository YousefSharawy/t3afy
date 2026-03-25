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

  // Form field state owned by the cubit
  final String selectedType;
  final bool isForceCompleted;
  final DateTime? selectedDate;
  final TimeOfDay? timeStart;
  final TimeOfDay? timeEnd;

  const CreateCampaignReady({
    required this.volunteers,
    required this.selectedIds,
    this.taskData,
    this.selectedType = 'توعية مدرسية',
    this.isForceCompleted = false,
    this.selectedDate,
    this.timeStart,
    this.timeEnd,
  });

  CreateCampaignReady copyWith({
    List<VolunteerEntity>? volunteers,
    Set<String>? selectedIds,
    Map<String, dynamic>? taskData,
    String? selectedType,
    bool? isForceCompleted,
    DateTime? selectedDate,
    TimeOfDay? timeStart,
    TimeOfDay? timeEnd,
    bool clearTaskData = false,
  }) {
    return CreateCampaignReady(
      volunteers: volunteers ?? this.volunteers,
      selectedIds: selectedIds ?? this.selectedIds,
      taskData: clearTaskData ? null : (taskData ?? this.taskData),
      selectedType: selectedType ?? this.selectedType,
      isForceCompleted: isForceCompleted ?? this.isForceCompleted,
      selectedDate: selectedDate ?? this.selectedDate,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
    );
  }
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

class CreateCampaignValidationError extends CreateCampaignState {
  final String message;
  const CreateCampaignValidationError(this.message);
}
