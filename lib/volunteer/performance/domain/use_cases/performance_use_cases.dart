import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/volunteer/performance/domain/repository/performance_repository.dart';

class GetPerformanceStats {
  final PerformanceRepository _repository;

  GetPerformanceStats(this._repository);

  Future<Either<Failture, PerformanceStatsEntity>> call(String userId) {
    return _repository.getPerformanceStats(userId);
  }
}

class GetMonthlyHours {
  final PerformanceRepository _repository;

  GetMonthlyHours(this._repository);

  Future<Either<Failture, List<MonthlyHoursEntity>>> call(String userId) {
    return _repository.getMonthlyHours(userId);
  }
}

class GetLeaderboard {
  final PerformanceRepository _repository;

  GetLeaderboard(this._repository);

  Future<Either<Failture, List<LeaderboardEntryEntity>>> call() {
    return _repository.getLeaderboard();
  }
}
