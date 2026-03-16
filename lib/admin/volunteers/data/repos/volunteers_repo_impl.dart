import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/data/datasources/volunteers_remote_datasource.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/domain/repos/volunteers_repo.dart';

class VolunteersRepoImpl implements VolunteersRepo {
  final VolunteersRemoteDatasource _datasource;
  RealtimeChannel? _channel;

  VolunteersRepoImpl(this._datasource);

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
}
