import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/local_storage.dart';
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

  RealtimeChannel? _assignmentsChannel;
  Timer? _debounce;
  String? _currentTaskId;

  void _onRealtimeChange() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_currentTaskId != null) _refresh(_currentTaskId!);
    });
  }

  void _subscribeToAssignments(String taskId) {
    _assignmentsChannel?.unsubscribe();
    _assignmentsChannel = Supabase.instance.client
        .channel('campaign_detail_assignments_$taskId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'task_assignments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'task_id',
            value: taskId,
          ),
          callback: (_) => _onRealtimeChange(),
        )
        .subscribe();
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _assignmentsChannel?.unsubscribe();
    return super.close();
  }

  Future<void> load(String taskId, {bool invalidateListCache = false}) async {
    if (_currentTaskId != taskId) {
      _currentTaskId = taskId;
      _subscribeToAssignments(taskId);
    }
    if (invalidateListCache) {
      await LocalAppStorage.invalidateCache('campaigns_list');
      await LocalAppStorage.invalidateCache('campaigns_stats');
    }
    emit(const CampaignDetailLoading());
    final result = await _getDetail(taskId);
    result.fold(
      (f) => emit(CampaignDetailError(f.message)),
      (detail) => emit(CampaignDetailLoaded(detail)),
    );
  }

  /// Silently re-fetches detail without emitting a Loading state.
  Future<void> _refresh(String taskId) async {
    final result = await _getDetail(taskId);
    result.fold(
      (_) {}, // swallow errors on background refresh
      (detail) => emit(CampaignDetailLoaded(detail)),
    );
  }

  CampaignDetailEntity? get _currentDetail {
    final s = state;
    if (s is CampaignDetailLoaded) return s.detail;
    return null;
  }

  Future<bool> assignVolunteers({
    required String taskId,
    required List<String> userIds,
    required String adminId,
  }) async {
    final result = await _assignVolunteer(
      taskId: taskId,
      userIds: userIds,
      adminId: adminId,
    );
    bool success = false;
    result.fold(
      (f) => emit(CampaignDetailActionError(f.message)),
      (_) => success = true,
    );
    if (success) await _refresh(taskId);
    return success;
  }

  Future<void> removeVolunteer({
    required String taskId,
    required String userId,
  }) async {
    final detail = _currentDetail;
    final result = await _removeVolunteer(taskId: taskId, userId: userId);
    await result.fold(
      (f) async => emit(CampaignDetailActionError(f.message)),
      (_) async {
        if (detail != null) {
          emit(CampaignDetailLoaded(
            detail.copyWith(
              members: detail.members.where((m) => m.id != userId).toList(),
            ),
          ));
        }
        await _refresh(taskId);
      },
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
    final detail = _currentDetail;
    final result = await _updateCampaign(taskId, {'status': 'paused'});
    await result.fold(
      (f) async => emit(CampaignDetailActionError(f.message)),
      (_) async {
        if (detail != null) {
          emit(CampaignDetailLoaded(detail.copyWith(status: 'paused')));
        }
        await _refresh(taskId);
      },
    );
  }

  Future<List<VolunteerEntity>> getUnassignedVolunteers(String taskId) async {
    final result = await _getUnassigned(taskId);
    return result.fold((f) => [], (list) => list);
  }
}
