import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/notifications/data/models/admin_notification_model.dart';
import 'package:t3afy/admin/notifications/data/sources/admin_notifications_remote_data_source.dart';
import 'package:t3afy/admin/notifications/domain/repository/admin_notifications_repository.dart';

class AdminNotificationsImplRepository
    implements AdminNotificationsRepository {
  final AdminNotificationsRemoteDataSource _dataSource;

  AdminNotificationsImplRepository(this._dataSource);

  @override
  Future<Either<Failture, List<AdminNotification>>> getNotifications(
      String adminId) async {
    try {
      final result = await _dataSource.getNotifications(adminId);
      return Right(result);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> markAsRead(String noteId) async {
    try {
      await _dataSource.markAsRead(noteId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> markAllAsRead(String adminId) async {
    try {
      await _dataSource.markAllAsRead(adminId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
