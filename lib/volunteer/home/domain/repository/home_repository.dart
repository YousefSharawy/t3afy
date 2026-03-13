import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

abstract class VolunteerHomeRepository {
  Future<Either<Failture, VolunteerStatsEntity>> getVolunteerStats(
    String userId,
  );
  Future<Either<Failture, List<TaskEntity>>> getTodayTasks(String userId);
}
