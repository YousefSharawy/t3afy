import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/notifications/data/models/admin_note_model.dart';
import 'package:t3afy/volunteer/notifications/data/sources/notifications_remote_data_source.dart';
import 'package:t3afy/volunteer/notifications/domain/repository/notifications_repository.dart';

class NotificationsImplRepository implements NotificationsRepository {
  final NotificationsRemoteDataSource _dataSource;

  NotificationsImplRepository(this._dataSource);

  @override
  Future<Either<Failture, List<AdminNote>>> getNotifications(
      String volunteerId) async {
    try {
      final result = await _dataSource.getNotifications(volunteerId);
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
  Future<Either<Failture, void>> markAllAsRead(String volunteerId) async {
    try {
      await _dataSource.markAllAsRead(volunteerId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
