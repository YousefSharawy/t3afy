import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart';
import 'package:t3afy/admin/home/domain/usecases/get_admin_home_data_usecase.dart';
import 'package:t3afy/admin/home/domain/usecases/send_announcement_usecase.dart';

part 'admin_home_state.dart';
part 'admin_home_cubit.freezed.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  AdminHomeCubit(
    this._getAdminHomeDataUsecase,
    this._sendAnnouncementUsecase,
  ) : super(const AdminHomeState.initial()) {
    loadDashboard();
  }

  final GetAdminHomeDataUsecase _getAdminHomeDataUsecase;
  final SendAnnouncementUsecase _sendAnnouncementUsecase;

  Future<void> loadDashboard() async {
    final adminId = LocalAppStorage.getUserId();
    if (adminId == null) {
      emit(const AdminHomeState.error('غير مصرح'));
      return;
    }
    emit(const AdminHomeState.loading());
    final result = await _getAdminHomeDataUsecase(adminId);
    result.fold(
      (f) => emit(AdminHomeState.error(f.message)),
      (data) => emit(AdminHomeState.loaded(data)),
    );
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
