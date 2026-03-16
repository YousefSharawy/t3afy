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
}
