import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/admin/volunteers/data/services/volunteer_pdf_service.dart';
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
import 'package:t3afy/core/data/safe_emit.dart';

class VolunteerDetailsCubit extends Cubit<VolunteerDetailsState>
    with SafeEmit<VolunteerDetailsState> {
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
    if (_currentDetails != null) return _refresh(volunteerId);
    emit(VolunteerDetailsLoading());
    final result = await _getDetails(volunteerId);
    result.fold(
      (f) => safeEmit(VolunteerDetailsError(f.message)),
      (details) => safeEmit(VolunteerDetailsLoaded(details)),
    );
  }

  /// Silently re-fetches without emitting a Loading state.
  Future<void> _refresh(String volunteerId) async {
    final result = await _getDetails(volunteerId);
    result.fold(
      (_) {}, // swallow errors on background refresh
      (details) => safeEmit(VolunteerDetailsLoaded(details)),
    );
  }

  Future<void> approveVolunteer(
    String volunteerId, {
    bool isPending = false,
  }) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsApproving(details));
    final result = await _approveVolunteer(volunteerId);
    result.fold(
      (f) => safeEmit(VolunteerDetailsActionError(details, f.message)),
      (_) {
        if (isPending) {
          safeEmit(VolunteerDetailsDecided(details, 'تم قبول المتطوع'));
        } else {
          _refresh(volunteerId);
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
      (f) => safeEmit(VolunteerDetailsActionError(details, f.message)),
      (_) => safeEmit(VolunteerDetailsDeleted()),
    );
  }

  Future<void> rejectVolunteer(String volunteerId) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsRejecting(details));
    final result = await _deleteVolunteer(volunteerId);
    result.fold(
      (f) => safeEmit(VolunteerDetailsActionError(details, f.message)),
      (_) => safeEmit(VolunteerDetailsDecided(details, 'تم رفض الطلب')),
    );
  }

  Future<void> loadAvailableTasks() async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _getAvailableTasks(details.id);
    result.fold(
      (f) => safeEmit(VolunteerDetailsActionError(details, f.message)),
      (tasks) => safeEmit(VolunteerDetailsAvailableTasks(details, tasks)),
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
    result.fold((f) => safeEmit(VolunteerDetailsActionError(details, f.message)), (
      _,
    ) {
      safeEmit(VolunteerDetailsActionSuccess(details, 'تم تعيين المهمة بنجاح'));
      _refresh(details.id);
    });
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
    result.fold((f) => safeEmit(VolunteerDetailsActionError(details, f.message)), (
      _,
    ) {
      safeEmit(VolunteerDetailsActionSuccess(details, 'تم تعيين المهمة بنجاح'));
      _refresh(details.id);
    });
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
      (f) => safeEmit(VolunteerDetailsActionError(details, f.message)),
      (_) => safeEmit(
        VolunteerDetailsActionSuccess(details, 'تم إرسال الرسالة بنجاح'),
      ),
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
    result.fold((f) => safeEmit(VolunteerDetailsActionError(details, f.message)), (
      _,
    ) {
      final updated = details.copyWith(rating: rating.toDouble());
      safeEmit(VolunteerDetailsActionSuccess(updated, 'تم تحديث التقييم'));
      _refresh(details.id);
    });
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
    result.fold((f) => safeEmit(VolunteerDetailsActionError(details, f.message)), (
      _,
    ) {
      final updated = details.copyWith(level: level, levelTitle: levelTitle);
      safeEmit(VolunteerDetailsActionSuccess(updated, 'تم تحديث المستوى'));
      _refresh(details.id);
    });
  }

  Future<void> editVolunteerData(Map<String, dynamic> fields) async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _editVolunteerData(
      volunteerId: details.id,
      fields: fields,
    );
    result.fold((f) => safeEmit(VolunteerDetailsActionError(details, f.message)), (
      _,
    ) {
      final updated = details.copyWith(
        name: fields['name'] as String? ?? details.name,
        phone: fields['phone'] as String? ?? details.phone,
        region: fields['region'] as String? ?? details.region,
        qualification:
            fields['qualification'] as String? ?? details.qualification,
      );
      safeEmit(VolunteerDetailsActionSuccess(updated, 'تم تحديث البيانات'));
      _refresh(details.id);
    });
  }

  Future<void> suspendAccount() async {
    final details = _currentDetails;
    if (details == null) return;
    emit(VolunteerDetailsActionLoading(details));
    final result = await _suspendAccount(details.id);
    result.fold(
      (f) => safeEmit(VolunteerDetailsActionError(details, f.message)),
      (_) => safeEmit(VolunteerDetailsSuspended()),
    );
  }

  Future<void> exportVolunteerPdf(VolunteerDetailsEntity details) async {
    if (state is VolunteerDetailsExporting) return;
    emit(VolunteerDetailsExporting(details));
    try {
      final client = Supabase.instance.client;
      final results = await Future.wait([
        _safeRows(
          'assessments',
          client
              .from('assessments')
              .select(
                'rating, comment, created_at, admin_id, users!assessments_admin_id_fkey(name)',
              )
              .eq('volunteer_id', details.id)
              .order('created_at', ascending: false),
        ),
        _safeRows(
          'tasks',
          client
              .from('task_assignments')
              .select(
                'status, checked_in_at, checked_out_at, verified_hours, is_verified, assigned_at, tasks!inner(title, type, date, duration_hours, time_start, time_end)',
              )
              .eq('user_id', details.id)
              .order('assigned_at', ascending: false),
        ),
      ]);

      late final Uint8List pdfBytes;
      try {
        pdfBytes = await VolunteerPdfService.generate(
          details: details,
          assessments: results[0],
          tasks: results[1],
        );
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('PDF creation error: $e\n$st');
        }
        safeEmit(VolunteerDetailsActionError(details, 'فشل إنشاء ملف PDF'));
        return;
      }

      try {
        final dir = await getTemporaryDirectory();
        final safeDate = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'volunteer_${details.name}_$safeDate.pdf';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(pdfBytes);

        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'تقرير بيانات المتطوع - ${details.name}',
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
        );
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('File save / share error: $e\n$st');
        }
        safeEmit(VolunteerDetailsActionError(details, 'فشل حفظ الملف'));
        return;
      }

      safeEmit(VolunteerDetailsActionSuccess(details, 'تم تصدير البيانات بنجاح'));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('General export error: $e\n$st');
      }
      safeEmit(VolunteerDetailsActionError(details, 'فشل تصدير البيانات'));
    }
  }

  /// A failed side query must not block the export; it just renders empty.
  Future<List<Map<String, dynamic>>> _safeRows(
    String label,
    Future<List<Map<String, dynamic>>> query,
  ) async {
    try {
      return await query;
    } catch (e, st) {
      if (kDebugMode) debugPrint('Failed to fetch $label: $e\n$st');
      return const [];
    }
  }

  VolunteerDetailsEntity? get _currentDetails => state.detailsOrNull;
}
