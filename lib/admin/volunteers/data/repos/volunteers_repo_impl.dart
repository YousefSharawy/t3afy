import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/data/datasources/volunteers_remote_datasource.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class VolunteersRepoImpl implements VolunteersRepo {
  final VolunteersRemoteDatasource _datasource;
  RealtimeChannel? _channel;

  VolunteersRepoImpl(this._datasource);

  @override
  Future<Either<Failture, void>> addVolunteer({
    required String name,
    required String email,
    String? phone,
    String? region,
    String? qualification,
  }) async {
    try {
      await _datasource.addVolunteer(
        name: name,
        email: email,
        phone: phone,
        region: region,
        qualification: qualification,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, List<AdminVolunteerEntity>>> getVolunteers() async {
    try {
      final list = await _datasource.getVolunteers();
      return Right(list);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, List<AdminVolunteerEntity>>> getPendingUsers() async {
    try {
      final list = await _datasource.getPendingUsers();
      return Right(list);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  void subscribeRealtime(void Function() onChanged) {
    _channel = _datasource.subscribeOnlineStatus(onChanged);
  }

  @override
  void disposeRealtime() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
  }

  @override
  Future<Either<Failture, VolunteerDetailsEntity>> getVolunteerDetails(
    String volunteerId,
  ) async {
    try {
      final details = await _datasource.getVolunteerDetails(volunteerId);
      return Right(details);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> deleteVolunteer(String volunteerId) async {
    try {
      await _datasource.deleteVolunteer(volunteerId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> approveVolunteer(String volunteerId) async {
    try {
      await _datasource.approveVolunteer(volunteerId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  // ── Volunteer Detail Actions ──

  @override
  Future<Either<Failture, List<Map<String, dynamic>>>> getAvailableTasks(
    String volunteerId,
  ) async {
    try {
      final tasks = await _datasource.getAvailableTasks(volunteerId);
      return Right(tasks);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> assignTask({
    required String volunteerId,
    required String taskId,
    required String adminId,
  }) async {
    try {
      await _datasource.assignTask(
        volunteerId: volunteerId,
        taskId: taskId,
        adminId: adminId,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> sendDirectMessage({
    required String adminId,
    required String volunteerId,
    required String title,
    required String body,
  }) async {
    try {
      await _datasource.sendDirectMessage(
        adminId: adminId,
        volunteerId: volunteerId,
        title: title,
        body: body,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> addRating({
    required String adminId,
    required String volunteerId,
    required int rating,
    String? comment,
  }) async {
    try {
      await _datasource.addRating(
        adminId: adminId,
        volunteerId: volunteerId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> upgradeLevel({
    required String volunteerId,
    required int level,
    required String levelTitle,
  }) async {
    try {
      await _datasource.upgradeLevel(
        volunteerId: volunteerId,
        level: level,
        levelTitle: levelTitle,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> editVolunteerData({
    required String volunteerId,
    required Map<String, dynamic> fields,
  }) async {
    try {
      await _datasource.editVolunteerData(
        volunteerId: volunteerId,
        fields: fields,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> assignCustomTask({
    required String volunteerId,
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
    try {
      await _datasource.assignCustomTask(
        volunteerId: volunteerId,
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
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> suspendAccount(String volunteerId) async {
    try {
      await _datasource.suspendAccount(volunteerId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
