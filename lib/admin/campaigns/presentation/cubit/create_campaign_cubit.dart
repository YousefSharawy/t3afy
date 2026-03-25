import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_all_volunteers_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/get_campaign_detail_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/create_campaign_usecase.dart';
import 'package:t3afy/admin/campaigns/domain/usecases/update_campaign_usecase.dart';
import 'package:t3afy/app/local_storage.dart';
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
IconData taskTypeIcon(String type) {
  switch (type) {
    case 'توعية مدرسية':
      return Icons.school_outlined;
    case 'توعية جامعية':
      return Icons.account_balance_outlined;
    case 'زيارة ميدانية':
      return Icons.map_outlined;
    case 'حملة توعوية':
      return Icons.campaign_outlined;
    case 'ورشة عمل':
      return Icons.handyman_outlined;
    case 'فعالية مجتمعية':
      return Icons.people_outline;
    case 'تدريب':
      return Icons.school_outlined;
    default:
      return Icons.volunteer_activism_outlined;
  }
}
const campaignStatusLabels = {
  'ongoing':   'جارية',
  'upcoming':  'قادمة',
  'completed': 'مكتملة',
  'active':    'نشطة',
  'suspended': 'موقوفة',
};

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

  CreateCampaignReady get _ready => state as CreateCampaignReady;

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

  // ── Load ──────────────────────────────────────────────────────────────────

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

        final existingStatus = detail.status == 'done' ? 'completed' : detail.status;
        emit(CreateCampaignReady(
          volunteers: List.from(_volunteers),
          selectedIds: Set.from(_selectedIds),
          taskData: taskData,
          selectedType: campaignTypes.contains(detail.type) ? detail.type : campaignTypes.first,
          isForceCompleted: existingStatus == 'completed',
          selectedDate: DateTime.tryParse(detail.date),
          timeStart: timeStart,
          timeEnd: timeEnd,
        ));
      },
    );
  }

  // ── Volunteers ────────────────────────────────────────────────────────────

  void toggleVolunteer(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    final current = state is CreateCampaignReady ? _ready : null;
    emit(CreateCampaignReady(
      volunteers: List.from(_volunteers),
      selectedIds: Set.from(_selectedIds),
      taskData: current?.taskData,
      selectedType: current?.selectedType ?? campaignTypes.first,
      isForceCompleted: current?.isForceCompleted ?? false,
      selectedDate: current?.selectedDate,
      timeStart: current?.timeStart,
      timeEnd: current?.timeEnd,
    ));
  }

  void addVolunteers(Set<String> ids) {
    _selectedIds.addAll(ids);
    final current = state is CreateCampaignReady ? _ready : null;
    emit(CreateCampaignReady(
      volunteers: List.from(_volunteers),
      selectedIds: Set.from(_selectedIds),
      taskData: current?.taskData,
      selectedType: current?.selectedType ?? campaignTypes.first,
      isForceCompleted: current?.isForceCompleted ?? false,
      selectedDate: current?.selectedDate,
      timeStart: current?.timeStart,
      timeEnd: current?.timeEnd,
    ));
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
    final campDay = DateTime(campaignDate.year, campaignDate.month, campaignDate.day);

    if (campDay.isAfter(today)) return 'upcoming';
    if (campDay.isBefore(today)) return 'completed';

    // Same day — check time
    final startParts = timeStart.split(':');
    final endParts = timeEnd.split(':');
    final startDT = DateTime(now.year, now.month, now.day,
        int.parse(startParts[0]), int.parse(startParts[1]));
    final endDT = DateTime(now.year, now.month, now.day,
        int.parse(endParts[0]), int.parse(endParts[1]));

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
    String? taskId,
  }) async {
    if (state is! CreateCampaignReady) return;
    final ready = _ready;

    if (ready.selectedDate == null) {
      emit(const CreateCampaignValidationError('يرجى اختيار تاريخ الحملة'));
      emit(ready);
      return;
    }
    if (ready.timeStart == null || ready.timeEnd == null) {
      emit(const CreateCampaignValidationError('يجب تحديد وقت البداية والنهاية'));
      emit(ready);
      return;
    }

    emit(const CreateCampaignSaving());

    final adminId = LocalAppStorage.getUserId() ?? '';
    final dateStr = ready.selectedDate!.toIso8601String().split('T')[0];
    final timeStartStr = formatTime(ready.timeStart!);
    final timeEndStr = formatTime(ready.timeEnd!);
    final resolvedStatus = resolveNewCampaignStatus(
      dateStr, timeStartStr, timeEndStr, ready.isForceCompleted,
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
      'supervisor_name': supervisorName,
      'supervisor_phone': supervisorPhone,
      'points': points == 0 ? 10 : points,
      'notes': notes,
      'target_beneficiaries': targetBeneficiaries,
      'objective_titles': objectiveTitles,
      'supplies_data': suppliesData,
      'volunteer_ids': _selectedIds.toList(),
    };
    if (taskId == null) formData['created_by'] = adminId;

    if (taskId != null) {
      final result = await _updateCampaign(taskId, formData);
      result.fold(
        (f) {
          emit(CreateCampaignActionError(f.message));
          emit(ready);
        },
        (_) => emit(const CreateCampaignSaved()),
      );
    } else {
      final result = await _createCampaign(formData);
      result.fold(
        (f) {
          emit(CreateCampaignActionError(f.message));
          emit(ready);
        },
        (_) => emit(const CreateCampaignSaved()),
      );
    }
  }
}
