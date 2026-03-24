import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/add_rating_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/assign_custom_task_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/approve_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/assign_task_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/delete_volunteer_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/edit_volunteer_data_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_available_tasks_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/get_volunteer_details_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/send_direct_message_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/suspend_account_usecase.dart';
import 'package:t3afy/admin/volunteers/domain/usecases/upgrade_level_usecase.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';

class VolunteerDetailsCubit extends Cubit<VolunteerDetailsState> {
  final GetVolunteerDetailsUsecase _getDetails;
  final DeleteVolunteerUsecase _deleteVolunteer;
  final ApproveVolunteerUsecase _approveVolunteer;
  final GetAvailableTasksUsecase _getAvailableTasks;
  final AssignTaskUsecase _assignTask;
  final SendDirectMessageUsecase _sendDirectMessage;
  final AddRatingUsecase _addRating;
  final UpgradeLevelUsecase _upgradeLevel;
  final EditVolunteerDataUsecase _editVolunteerData;
  final SuspendAccountUsecase _suspendAccount;
  final AssignCustomTaskUsecase _assignCustomTask;

  VolunteerDetailsCubit(
    this._getDetails,
    this._deleteVolunteer,
    this._approveVolunteer,
    this._getAvailableTasks,
    this._assignTask,
    this._sendDirectMessage,
    this._addRating,
    this._upgradeLevel,
    this._editVolunteerData,
    this._suspendAccount,
    this._assignCustomTask,
  ) : super(VolunteerDetailsInitial());

  Future<void> load(String volunteerId) async {
    emit(VolunteerDetailsLoading());
    final result = await _getDetails(volunteerId);
    result.fold(
      (f) => emit(VolunteerDetailsError(f.message)),
      (details) => emit(VolunteerDetailsLoaded(details)),
    );
  }

  /// Silently re-fetches without emitting a Loading state.
  Future<void> _refresh(String volunteerId) async {
    final result = await _getDetails(volunteerId);
    result.fold(
      (_) {}, // swallow errors on background refresh
      (details) => emit(VolunteerDetailsLoaded(details)),
    );
  }

  Future<void> approveVolunteer(String volunteerId, {bool isPending = false}) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsLoading());
    final result = await _approveVolunteer(volunteerId);
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        if (isPending) {
          emit(VolunteerDetailsActionSuccess(details, 'تم قبول المتطوع'));
        } else {
          load(volunteerId);
        }
      },
    );
  }

  Future<void> deleteVolunteer(String volunteerId) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsDeleting(details));
    final result = await _deleteVolunteer(volunteerId);
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) => emit(VolunteerDetailsDeleted()),
    );
  }

  Future<void> rejectVolunteer(String volunteerId) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _deleteVolunteer(volunteerId);
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) => emit(VolunteerDetailsActionSuccess(details, 'تم رفض الطلب')),
    );
  }

  Future<void> loadAvailableTasks() async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _getAvailableTasks(details.id);
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (tasks) => emit(VolunteerDetailsAvailableTasks(details, tasks)),
    );
  }

  Future<void> assignTask({
    required String taskId,
    required String adminId,
  }) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _assignTask(
      volunteerId: details.id,
      taskId: taskId,
      adminId: adminId,
    );
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        emit(VolunteerDetailsActionSuccess(details, 'تم تعيين المهمة بنجاح'));
        _refresh(details.id);
      },
    );
  }

  Future<void> assignCustomTask({
    required String adminId,
    required String title,
    required String type,
    String? description,
    required String locationName,
    String? locationAddress,
    required String date,
    required String timeStart,
    required String timeEnd,
    required double durationHours,
    required int points,
    String? supervisorName,
    String? supervisorPhone,
    String? notes,
  }) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _assignCustomTask(
      volunteerId: details.id,
      adminId: adminId,
      title: title,
      type: type,
      description: description,
      locationName: locationName,
      locationAddress: locationAddress,
      date: date,
      timeStart: timeStart,
      timeEnd: timeEnd,
      durationHours: durationHours,
      points: points,
      supervisorName: supervisorName,
      supervisorPhone: supervisorPhone,
      notes: notes,
    );
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        emit(VolunteerDetailsActionSuccess(details, 'تم تعيين المهمة بنجاح'));
        _refresh(details.id);
      },
    );
  }

  Future<void> sendDirectMessage({
    required String adminId,
    required String title,
    required String body,
  }) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _sendDirectMessage(
      adminId: adminId,
      volunteerId: details.id,
      title: title,
      body: body,
    );
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) =>
          emit(VolunteerDetailsActionSuccess(details, 'تم إرسال الرسالة بنجاح')),
    );
  }

  Future<void> addRating({
    required String adminId,
    required int rating,
    String? comment,
  }) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _addRating(
      adminId: adminId,
      volunteerId: details.id,
      rating: rating,
      comment: comment,
    );
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        final updated = details.copyWith(rating: rating.toDouble());
        emit(VolunteerDetailsLoaded(updated));
        _refresh(details.id);
      },
    );
  }

  Future<void> upgradeLevel({
    required int level,
    required String levelTitle,
  }) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _upgradeLevel(
      volunteerId: details.id,
      level: level,
      levelTitle: levelTitle,
    );
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        final updated = details.copyWith(level: level, levelTitle: levelTitle);
        emit(VolunteerDetailsLoaded(updated));
        _refresh(details.id);
      },
    );
  }

  Future<void> editVolunteerData(Map<String, dynamic> fields) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _editVolunteerData(
      volunteerId: details.id,
      fields: fields,
    );
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        final updated = details.copyWith(
          name: fields['name'] as String? ?? details.name,
          phone: fields['phone'] as String? ?? details.phone,
          region: fields['region'] as String? ?? details.region,
          qualification: fields['qualification'] as String? ?? details.qualification,
        );
        emit(VolunteerDetailsLoaded(updated));
        _refresh(details.id);
      },
    );
  }

  Future<void> suspendAccount() async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _suspendAccount(details.id);
    result.fold(
      (f) => emit(VolunteerDetailsActionError(details, f.message)),
      (_) => emit(VolunteerDetailsSuspended()),
    );
  }

  /// Helper to extract details from any state that carries them.
  VolunteerDetailsEntity? get _currentDetails {
    final s = state;
    if (s is VolunteerDetailsLoaded) return s.details;
    if (s is VolunteerDetailsDeleting) return s.details;
    if (s is VolunteerDetailsActionError) return s.details;
    if (s is VolunteerDetailsActionLoading) return s.details;
    if (s is VolunteerDetailsActionSuccess) return s.details;
    if (s is VolunteerDetailsAvailableTasks) return s.details;
    return null;
  }
}
