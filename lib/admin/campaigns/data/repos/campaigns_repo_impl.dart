import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/failture.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/entities/campaign_detail_entity.dart';
import '../../domain/entities/volunteer_entity.dart';
import '../../domain/repos/campaigns_repo.dart';
import '../datasources/campaigns_remote_datasource.dart';

class CampaignsRepoImpl implements CampaignsRepo {
  final CampaignsRemoteDatasource _datasource;
  RealtimeChannel? _channel;

  CampaignsRepoImpl(this._datasource);

  @override
  void subscribeRealtime(void Function() onChanged) {
    _channel = _datasource.subscribeCampaignsChanges(onChanged);
  }

  @override
  void disposeRealtime() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
  }

  @override
  Future<Either<Failture, List<CampaignEntity>>> getCampaigns() async {
    try {
      return Right(await _datasource.getCampaigns());
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, Map<String, int>>> getCampaignStats() async {
    try {
      return Right(await _datasource.getCampaignStats());
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, CampaignDetailEntity>> getCampaignDetail(String id) async {
    try {
      return Right(await _datasource.getCampaignDetail(id));
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, String>> createCampaign(Map<String, dynamic> data) async {
    try {
      return Right(await _datasource.createCampaign(data));
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> updateCampaign(String id, Map<String, dynamic> data) async {
    try {
      await _datasource.updateCampaign(id, data);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> deleteCampaign(String id) async {
    try {
      await _datasource.deleteCampaign(id);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> assignVolunteer({
    required String taskId,
    required String userId,
    required String adminId,
  }) async {
    try {
      await _datasource.assignVolunteer(taskId: taskId, userId: userId, adminId: adminId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> removeVolunteer({
    required String taskId,
    required String userId,
  }) async {
    try {
      await _datasource.removeVolunteer(taskId: taskId, userId: userId);
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, void>> sendTeamAlert({
    required String taskId,
    required String adminId,
    required String title,
    required String body,
    required List<String> volunteerIds,
  }) async {
    try {
      await _datasource.sendTeamAlert(
        taskId: taskId,
        adminId: adminId,
        title: title,
        body: body,
        volunteerIds: volunteerIds,
      );
      return const Right(null);
    } on Failture catch (f) {
      return Left(f);
    }
  }

  @override
  Future<Either<Failture, List<VolunteerEntity>>> getUnassignedVolunteers(String taskId) async {
    try {
      return Right(await _datasource.getUnassignedVolunteers(taskId));
    } on Failture catch (f) {
      return Left(f);
    }
  }
}
