import 'package:t3afy/app/resources/app_icons.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_all_volunteers_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_detail_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/create_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/update_campaign_usecase.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/core/data/safe_emit.dart';
part 'create_campaign_state.dart';

// ── Static campaign config ─────────────────────────────────────────────────
const campaignTypes = [
  'توعية مدرسية',
  'توعية جامعية',
  'زيارة ميدانية',
  'حملة توعوية',
  'ورشة عمل',
  'فعالية مجتمعية',
  'تدريب',
  'أخرى',
];

/// Returns the Material icon that best represents a campaign/task type.
IconData taskTypeIcon(String type) => AppIcons.taskType(type);

const campaignStatusLabels = {
  'ongoing': 'جارية',
  'upcoming': 'قادمة',
  'completed': 'مكتملة',
  'active': 'نشطة',
  'suspended': 'موقوفة',
};

class CreateCampaignCubit extends Cubit<CreateCampaignState>
    with SafeEmit<CreateCampaignState> {
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

  CreateCampaignReady get _ready => state as CreateCampaignReady;

  CreateCampaignReady? _lastReady;

  /// The form values, also while a save is running or an error is being
  /// shown (those states carry no data). Sections select from this so the
  /// form never blanks and only the changed section rebuilds.
  CreateCampaignReady? get form =>
      state is CreateCampaignReady ? _ready : _lastReady;

  @override
  void onChange(Change<CreateCampaignState> change) {
    super.onChange(change);
    final next = change.nextState;
    if (next is CreateCampaignReady) _lastReady = next;
  }

  // ── Field setters ─────────────────────────────────────────────────────────

  void setType(String type) =>
      emit(_ready.copyWith(selectedType: type, clearTaskData: true));

  void setForceCompleted(bool value) =>
      emit(_ready.copyWith(isForceCompleted: value));

  void setDate(DateTime date) =>
      emit(_ready.copyWith(selectedDate: date, clearTaskData: true));

  void setTimeStart(TimeOfDay time) =>
      emit(_ready.copyWith(timeStart: time, clearTaskData: true));

  void setTimeEnd(TimeOfDay time) =>
      emit(_ready.copyWith(timeEnd: time, clearTaskData: true));

  void setLocation(double lat, double lng) =>
      emit(_ready.copyWith(locationLat: lat, locationLng: lng));

  void clearLocation() => emit(_ready.copyWith(clearLocation: true));

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadVolunteers() async {
    emit(const CreateCampaignLoading());
    final result = await _getAllVolunteers();
    result.fold((f) => safeEmit(CreateCampaignError(f.message)), (volunteers) {
      _volunteers = volunteers;
      _selectedIds = {};
      safeEmit(
        CreateCampaignReady(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
        ),
      );
    });
  }

  /// Pull-to-refresh in the volunteer picker: bypasses the 5-minute cache and
  /// keeps the form (and the current selection) as it is.
  Future<void> refreshVolunteers() async {
    final result = await _getAllVolunteers(skipCache: true);
    result.fold((_) {}, (volunteers) {
      _volunteers = volunteers;
      if (state is CreateCampaignReady) {
        safeEmit(
          _ready.copyWith(
            volunteers: List.from(_volunteers),
            clearTaskData: true,
          ),
        );
      }
    });
  }

  Future<void> loadForEdit(String taskId) async {
    emit(const CreateCampaignLoading());

    final (volunteersResult, detailResult) = await (
      _getAllVolunteers(),
      _getCampaignDetail(taskId),
    ).wait;
    String? volunteersError;
    volunteersResult.fold(
      (f) => volunteersError = f.message,
      (v) => _volunteers = v,
    );
    if (volunteersError != null) {
      safeEmit(CreateCampaignError(volunteersError!));
      return;
    }

    detailResult.fold((f) => safeEmit(CreateCampaignError(f.message)), (detail) {
      _selectedIds = detail.members.map((m) => m.id).toSet();

      // Parse time strings into TimeOfDay
      TimeOfDay? timeStart;
      TimeOfDay? timeEnd;
      if (detail.timeStart != null) {
        final parts = detail.timeStart!.split(':');
        if (parts.length >= 2) {
          timeStart = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }
      if (detail.timeEnd != null) {
        final parts = detail.timeEnd!.split(':');
        if (parts.length >= 2) {
          timeEnd = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }

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
        'location_lat': detail.locationLat,
        'location_lng': detail.locationLng,
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

      final existingStatus = detail.status == 'done'
          ? 'completed'
          : detail.status;
      safeEmit(
        CreateCampaignReady(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
          taskData: taskData,
          selectedType: campaignTypes.contains(detail.type)
              ? detail.type
              : campaignTypes.first,
          isForceCompleted: existingStatus == 'completed',
          selectedDate: DateTime.tryParse(detail.date),
          timeStart: timeStart,
          timeEnd: timeEnd,
          locationLat: detail.locationLat,
          locationLng: detail.locationLng,
        ),
      );
    });
  }

  // ── Volunteers ────────────────────────────────────────────────────────────

  void toggleVolunteer(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    if (state is CreateCampaignReady) {
      emit(
        _ready.copyWith(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
        ),
      );
    }
  }

  /// Replaces the team with the picker's selection (unticking removes).
  void setVolunteers(Set<String> ids) {
    _selectedIds = Set.of(ids);
    if (state is CreateCampaignReady) {
      emit(
        _ready.copyWith(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
        ),
      );
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  static String formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String resolveNewCampaignStatus(
    String date,
    String timeStart,
    String timeEnd,
    bool forceCompleted,
  ) {
    if (forceCompleted) return 'completed';
    final now = DateTime.now();
    final campaignDate = DateTime.parse(date);
    final today = DateTime(now.year, now.month, now.day);
    final campDay = DateTime(
      campaignDate.year,
      campaignDate.month,
      campaignDate.day,
    );

    if (campDay.isAfter(today)) return 'upcoming';
    if (campDay.isBefore(today)) return 'completed';

    // Same day — check time
    final startParts = timeStart.split(':');
    final endParts = timeEnd.split(':');
    final startDT = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );
    final endDT = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    if (now.isBefore(startDT)) return 'upcoming';
    if (now.isAfter(endDT)) return 'completed';
    return 'active';
  }

  /// Validates date/time, assembles formData, and saves. Returns the error
  /// message if validation fails (so the view can show a snackbar), otherwise
  /// null on success.
  Future<void> save({
    required String title,
    required String? description,
    required String? locationName,
    required String? locationAddress,
    required String? supervisorName,
    required String? supervisorPhone,
    required int points,
    required String? notes,
    required int targetBeneficiaries,
    required List<String> objectiveTitles,
    required List<Map<String, dynamic>> suppliesData,
    required List<File> paperFiles,
    String? taskId,
    double? locationLat,
    double? locationLng,
  }) async {
    if (state is! CreateCampaignReady) return;
    final ready = _ready;

    if (ready.selectedDate == null) {
      emit(const CreateCampaignValidationError('يرجى اختيار تاريخ الحملة'));
      emit(ready);
      return;
    }
    if (ready.timeStart == null || ready.timeEnd == null) {
      emit(
        const CreateCampaignValidationError('يجب تحديد وقت البداية والنهاية'),
      );
      emit(ready);
      return;
    }

    emit(const CreateCampaignSaving());

    final adminId = LocalAppStorage.getUserId() ?? '';
    final dateStr = ready.selectedDate!.toIso8601String().split('T')[0];
    final timeStartStr = formatTime(ready.timeStart!);
    final timeEndStr = formatTime(ready.timeEnd!);
    final resolvedStatus = resolveNewCampaignStatus(
      dateStr,
      timeStartStr,
      timeEndStr,
      ready.isForceCompleted,
    );
    final formData = <String, dynamic>{
      'title': title,
      'type': ready.selectedType,
      'description': description,
      'status': resolvedStatus,
      'date': dateStr,
      'time_start': timeStartStr,
      'time_end': timeEndStr,
      'location_name': locationName,
      'location_address': locationAddress,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'supervisor_name': supervisorName,
      'supervisor_phone': supervisorPhone,
      'points': points == 0 ? 10 : points,
      'notes': notes,
      'target_beneficiaries': targetBeneficiaries,
      'objective_titles': objectiveTitles,
      'supplies_data': suppliesData,
      'volunteer_ids': _selectedIds.toList(),
      'paper_files': paperFiles,
    };
    if (taskId == null) {
      formData['created_by'] = adminId;
    } else {
      formData['updated_by'] = adminId;
    }

    if (taskId != null) {
      final result = await _updateCampaign(taskId, formData);
      result.fold((f) {
        safeEmit(CreateCampaignActionError(f.message));
        safeEmit(ready);
      }, (_) => safeEmit(const CreateCampaignSaved()));
    } else {
      final result = await _createCampaign(formData);
      result.fold((f) {
        safeEmit(CreateCampaignActionError(f.message));
        safeEmit(ready);
      }, (_) => safeEmit(const CreateCampaignSaved()));
    }
  }
}
