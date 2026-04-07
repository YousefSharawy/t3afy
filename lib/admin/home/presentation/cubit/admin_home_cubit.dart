import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:t3afy/admin/home/data/models/analytics_data_model.dart';
import 'package:t3afy/admin/home/data/services/analytics_pdf_service.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/admin/home/domain/repos/admin_home_repo.dart';
import 'package:t3afy/admin/home/domain/usecases/get_admin_home_data_usecase.dart';
import 'package:t3afy/admin/home/domain/usecases/send_announcement_usecase.dart';

part 'admin_home_state.dart';
part 'admin_home_cubit.freezed.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  AdminHomeCubit(
    this._getAdminHomeDataUsecase,
    this._sendAnnouncementUsecase,
    this._repo,
  ) : super(const AdminHomeState.initial()) {
    loadDashboard();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => loadDashboard(),
    );
  }

  final GetAdminHomeDataUsecase _getAdminHomeDataUsecase;
  final SendAnnouncementUsecase _sendAnnouncementUsecase;
  final AdminHomeRepo _repo;
  Timer? _refreshTimer;
  bool _isFirstLoad = true;
  AdminHomeDataEntity? _lastLoadedData;

  Future<void> loadDashboard() async {
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) {
      emit(const AdminHomeState.error('غير مصرح'));
      return;
    }
    if (_isFirstLoad) emit(const AdminHomeState.loading());
    final result = await _getAdminHomeDataUsecase(adminId);
    result.fold((f) => emit(AdminHomeState.error(f.message)), (data) {
      _isFirstLoad = false;
      _lastLoadedData = data;
      emit(AdminHomeState.loaded(data));
    });
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    _repo.disposeRealtime();
    return super.close();
  }

  Future<void> exportFullAnalyticsPdf() async {
    emit(const AdminHomeState.exportingPdf());
    try {
      final AnalyticsDataModel data;
      try {
        data = await AnalyticsPdfService.fetchAllData();
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('Data fetch error: $e\n$st');
        }
        emit(const AdminHomeState.exportError('فشل جلب البيانات'));
        return;
      }

      late final Uint8List pdfBytes;
      try {
        // Pre-load fonts in main thread
        final fonts = await AnalyticsPdfService.loadFonts();
        pdfBytes = await AnalyticsPdfService.generate(data, fonts: fonts);
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('PDF creation error: $e\n$st');
        }
        emit(const AdminHomeState.exportError('فشل إنشاء ملف PDF'));
        return;
      }

      try {
        final dir = await getTemporaryDirectory();
        final fileName =
            'T3afy_Analytics_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(pdfBytes);

        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'التقرير التحليلي الشامل — تعافي',
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
        );
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('File save / share error: $e\n$st');
        }
        emit(const AdminHomeState.exportError('فشل حفظ الملف'));
        return;
      }

      // Emit success and keep it visible for minimum duration
      emit(const AdminHomeState.exportSuccess());

      // Keep success state visible for 2 seconds before returning to loaded
      await Future.delayed(const Duration(seconds: 2));

      if (!isClosed && _lastLoadedData != null) {
        emit(AdminHomeState.loaded(_lastLoadedData!));
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('PDF Export General Error: $e\n$st');
      }
      emit(
        const AdminHomeState.exportError('فشل إنشاء التقرير، حاول مرة أخرى'),
      );
    }
  }

  Future<void> sendAnnouncement({
    required String title,
    required String body,
  }) async {
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) {
      emit(const AdminHomeState.announcementError('غير مصرح'));
      return;
    }

    emit(const AdminHomeState.announcementSending());

    final result = await _sendAnnouncementUsecase(
      title: title,
      body: body,
      adminId: adminId,
    );

    result.fold(
      (f) => emit(AdminHomeState.announcementError(f.message)),
      (_) => emit(const AdminHomeState.announcementSent()),
    );
  }
}
