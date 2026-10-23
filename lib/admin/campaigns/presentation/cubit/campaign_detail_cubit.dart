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
import 'package:t3afy/core/data/realtime_hub.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'campaign_detail_state.dart';

class CampaignDetailCubit extends Cubit<CampaignDetailState>
    with SafeEmit<CampaignDetailState> {
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

  RealtimeHub? _hub;
  String? _currentTaskId;

  /// Last good detail. Action states (saving, errors) don't carry data, so
  /// the screen keeps showing this one.
  CampaignDetailEntity? _detail;
  CampaignDetailEntity? get detail => _detail;

  /// True once anything on this campaign was changed from this screen, so the
  /// list only reloads when it has to.
  bool _changed = false;
  bool get hasChanges => _changed;

  void _watch(String taskId) {
    _hub?.dispose();
    // One callback for every watch so a burst refetches once.
    void refresh() => _refresh(taskId);
    _hub = RealtimeHub()
      ..watch(
        name: 'campaign-detail-assignments',
        table: 'task_assignments',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'task_id',
          value: taskId,
        ),
        onChange: refresh,
      )
      // Edited / paused from another manager's device.
      ..watch(
        name: 'campaign-detail-task',
        table: 'tasks',
        event: PostgresChangeEvent.update,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: taskId,
        ),
        onChange: refresh,
      )
      // Team member removed elsewhere. Deletes can't be filtered server-side.
      ..watch(
        name: 'campaign-detail-assignments-del',
        table: 'task_assignments',
        event: PostgresChangeEvent.delete,
        ignore: (p) => deletedRowNotFor(p, 'task_id', taskId),
        onChange: refresh,
      );
  }

  @override
  Future<void> close() async {
    await _hub?.dispose();
    return super.close();
  }

  Future<void> load(String taskId, {bool invalidateListCache = false}) async {
    if (_currentTaskId != taskId) {
      _currentTaskId = taskId;
      _detail = null;
      _watch(taskId);
    }
    if (invalidateListCache) {
      _changed = true;
      await _invalidateListCaches();
    }
    if (_detail == null) {
      safeEmit(const CampaignDetailLoading());
      final result = await _getDetail(taskId);
      result.fold(
        (f) => safeEmit(CampaignDetailError(f.message)),
        _emitDetail,
      );
    } else {
      await _refresh(taskId);
    }
  }

  void _emitDetail(CampaignDetailEntity detail) {
    _detail = detail;
    safeEmit(CampaignDetailLoaded(detail));
  }

  /// Re-fetches without a loading state; errors keep the data on screen.
  Future<void> _refresh(String taskId) async {
    final result = await _getDetail(taskId);
    result.fold((_) {}, _emitDetail);
  }

  /// Shows the error (listener toasts it) and puts the data state back.
  void _actionError(String message) {
    safeEmit(CampaignDetailActionError(message));
    if (_detail != null) safeEmit(CampaignDetailLoaded(_detail!));
  }

  Future<void> _invalidateListCaches() => Future.wait([
    LocalAppStorage.invalidateCache('campaigns_list'),
    LocalAppStorage.invalidateCache('campaigns_stats'),
  ]);

  Future<void> _afterChange(String taskId) async {
    _changed = true;
    await _invalidateListCaches();
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
    return result.fold(
      (f) {
        _actionError(f.message);
        return false;
      },
      (_) async {
        await _afterChange(taskId);
        await _refresh(taskId);
        return true;
      },
    );
  }

  Future<void> removeVolunteer({
    required String taskId,
    required String userId,
  }) async {
    final result = await _removeVolunteer(taskId: taskId, userId: userId);
    await result.fold((f) async => _actionError(f.message), (_) async {
      await _afterChange(taskId);
      final detail = _detail;
      if (detail != null) {
        _emitDetail(
          detail.copyWith(
            members: detail.members.where((m) => m.id != userId).toList(),
          ),
        );
      }
      await _refresh(taskId);
    });
  }

  /// Returns true when the alert was sent.
  Future<bool> sendAlert({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  }) async {
    safeEmit(const CampaignDetailSaving());
    final result = await _sendAlert(
      taskId: taskId,
      adminId: adminId,
      title: title,
      body: body,
      volunteerIds: volunteerIds,
    );
    return result.fold(
      (f) {
        _actionError(f.message);
        return false;
      },
      (_) {
        safeEmit(const CampaignDetailAlertSent());
        if (_detail != null) safeEmit(CampaignDetailLoaded(_detail!));
        return true;
      },
    );
  }

  Future<bool> deleteCampaign(String taskId) async {
    safeEmit(const CampaignDetailSaving());
    final result = await _deleteCampaign(taskId);
    return result.fold(
      (f) {
        _actionError(f.message);
        return false;
      },
      (_) async {
        await _afterChange(taskId);
        safeEmit(const CampaignDetailDeleted());
        return true;
      },
    );
  }

  Future<void> pauseCampaign(String taskId) async {
    final result = await _updateCampaign(taskId, {'status': 'paused'});
    await result.fold((f) async => _actionError(f.message), (_) async {
      await _afterChange(taskId);
      final detail = _detail;
      if (detail != null) _emitDetail(detail.copyWith(status: 'paused'));
      await _refresh(taskId);
    });
  }

  Future<List<VolunteerEntity>> getUnassignedVolunteers(String taskId) async {
    final result = await _getUnassigned(taskId);
    return result.fold((f) => [], (list) => list);
  }
}
