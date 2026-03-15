import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_detail_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/assign_volunteer_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/remove_volunteer_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/send_team_alert_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/delete_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/update_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_unassigned_volunteers_usecase.dart';

part 'campaign_detail_state.dart';

class CampaignDetailCubit extends Cubit<CampaignDetailState> {
  CampaignDetailCubit(
    this._getDetail,
    this._assignVolunteer,
    this._removeVolunteer,
    this._sendAlert,
    this._deleteCampaign,
    this._updateCampaign,
    this._getUnassigned,
  ) : super(const CampaignDetailInitial());

  final GetCampaignDetailUsecase _getDetail;
  final AssignVolunteerUsecase _assignVolunteer;
  final RemoveVolunteerUsecase _removeVolunteer;
  final SendTeamAlertUsecase _sendAlert;
  final DeleteCampaignUsecase _deleteCampaign;
  final UpdateCampaignUsecase _updateCampaign;
  final GetUnassignedVolunteersUsecase _getUnassigned;

  Future<void> load(String taskId) async {
    emit(const CampaignDetailLoading());
    final result = await _getDetail(taskId);
    result.fold(
      (f) => emit(CampaignDetailError(f.message)),
      (detail) => emit(CampaignDetailLoaded(detail)),
    );
  }

  Future<void> assignVolunteer({
    required String taskId,
    required String userId,
    required String adminId,
  }) async {
    final result = await _assignVolunteer(
      taskId: taskId,
      userId: userId,
      adminId: adminId,
    );
    result.fold(
      (f) => emit(CampaignDetailActionError(f.message)),
      (_) => load(taskId),
    );
  }

  Future<void> removeVolunteer({
    required String taskId,
    required String userId,
  }) async {
    final result = await _removeVolunteer(taskId: taskId, userId: userId);
    result.fold(
      (f) => emit(CampaignDetailActionError(f.message)),
      (_) => load(taskId),
    );
  }

  Future<void> sendAlert({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  }) async {
    emit(const CampaignDetailSaving());
    final result = await _sendAlert(
      taskId: taskId,
      adminId: adminId,
      title: title,
      body: body,
      volunteerIds: volunteerIds,
    );
    result.fold(
      (f) => emit(CampaignDetailActionError(f.message)),
      (_) => emit(const CampaignDetailAlertSent()),
    );
  }

  Future<bool> deleteCampaign(String taskId) async {
    emit(const CampaignDetailSaving());
    final result = await _deleteCampaign(taskId);
    return result.fold(
      (f) {
        emit(CampaignDetailActionError(f.message));
        return false;
      },
      (_) {
        emit(const CampaignDetailDeleted());
        return true;
      },
    );
  }

  Future<void> pauseCampaign(String taskId) async {
    final result = await _updateCampaign(taskId, {'status': 'paused'});
    result.fold(
      (f) => emit(CampaignDetailActionError(f.message)),
      (_) => load(taskId),
    );
  }

  Future<List<VolunteerEntity>> getUnassignedVolunteers(String taskId) async {
    final result = await _getUnassigned(taskId);
    return result.fold((f) => [], (list) => list);
  }
}
