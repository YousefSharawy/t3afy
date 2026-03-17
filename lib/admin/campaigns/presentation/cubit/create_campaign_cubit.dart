import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_all_volunteers_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_detail_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/create_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/update_campaign_usecase.dart';

part 'create_campaign_state.dart';

class CreateCampaignCubit extends Cubit<CreateCampaignState> {
  CreateCampaignCubit(
    this._getAllVolunteers,
    this._getCampaignDetail,
    this._createCampaign,
    this._updateCampaign,
  ) : super(const CreateCampaignInitial());

  final GetAllVolunteersUsecase _getAllVolunteers;
  final GetCampaignDetailUsecase _getCampaignDetail;
  final CreateCampaignUsecase _createCampaign;
  final UpdateCampaignUsecase _updateCampaign;

  List<VolunteerEntity> _volunteers = [];
  Set<String> _selectedIds = {};

  /// Loads all volunteers for the create-campaign form.
  Future<void> loadVolunteers() async {
    emit(const CreateCampaignLoading());
    final result = await _getAllVolunteers();
    result.fold(
      (f) => emit(CreateCampaignError(f.message)),
      (volunteers) {
        _volunteers = volunteers;
        _selectedIds = {};
        emit(CreateCampaignReady(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
        ));
      },
    );
  }

  /// Loads all volunteers AND the existing campaign data for the edit form.
  Future<void> loadForEdit(String taskId) async {
    emit(const CreateCampaignLoading());

    bool hasError = false;
    String errorMsg = '';

    final volunteersResult = await _getAllVolunteers();
    volunteersResult.fold(
      (f) {
        hasError = true;
        errorMsg = f.message;
      },
      (v) => _volunteers = v,
    );
    if (hasError) {
      emit(CreateCampaignError(errorMsg));
      return;
    }

    final detailResult = await _getCampaignDetail(taskId);
    detailResult.fold(
      (f) => emit(CreateCampaignError(f.message)),
      (detail) {
        _selectedIds = detail.members.map((m) => m.id).toSet();
        final taskData = <String, dynamic>{
          'title': detail.title,
          'description': detail.description,
          'type': detail.type,
          'status': detail.status,
          'date': detail.date,
          'time_start': detail.timeStart,
          'time_end': detail.timeEnd,
          'location_name': detail.locationName,
          'location_address': detail.locationAddress,
          'supervisor_name': detail.supervisorName,
          'supervisor_phone': detail.supervisorPhone,
          'points': detail.points,
          'notes': detail.notes,
          'target_beneficiaries': detail.targetBeneficiaries,
          'objectives': detail.objectives.map((o) => o.title).toList(),
          'supplies': detail.supplies
              .map((s) => {'name': s.name, 'quantity': s.quantity})
              .toList(),
        };
        emit(CreateCampaignReady(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
          taskData: taskData,
        ));
      },
    );
  }

  /// Toggles a volunteer in/out of the selected set.
  void toggleVolunteer(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    final currentTaskData =
        state is CreateCampaignReady ? (state as CreateCampaignReady).taskData : null;
    emit(CreateCampaignReady(
      volunteers: List.from(_volunteers),
      selectedIds: Set.from(_selectedIds),
      taskData: currentTaskData,
    ));
  }

  /// Saves the campaign (create or update). [formData] is the raw map from the
  /// view (without volunteer_ids — those are injected here from internal state).
  Future<void> save({
    required Map<String, dynamic> formData,
    String? taskId,
  }) async {
    emit(const CreateCampaignSaving());
    formData['volunteer_ids'] = _selectedIds.toList();

    if (taskId != null) {
      final result = await _updateCampaign(taskId, formData);
      result.fold(
        (f) {
          emit(CreateCampaignActionError(f.message));
          emit(CreateCampaignReady(
            volunteers: List.from(_volunteers),
            selectedIds: Set.from(_selectedIds),
          ));
        },
        (_) => emit(const CreateCampaignSaved()),
      );
    } else {
      final result = await _createCampaign(formData);
      result.fold(
        (f) {
          emit(CreateCampaignActionError(f.message));
          emit(CreateCampaignReady(
            volunteers: List.from(_volunteers),
            selectedIds: Set.from(_selectedIds),
          ));
        },
        (_) => emit(const CreateCampaignSaved()),
      );
    }
  }
}
