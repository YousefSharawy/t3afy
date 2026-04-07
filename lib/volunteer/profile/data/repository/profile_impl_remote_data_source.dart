import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/volunteer/profile/data/mapper/profile_mapper.dart';
import 'package:t3afy/volunteer/profile/data/source/profile_data_source.dart';
import 'package:t3afy/volunteer/profile/domain/entity/profile_entity.dart';
import 'package:t3afy/volunteer/profile/domain/repository/profile_repository.dart';

class ProfileImplRepository implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  ProfileImplRepository(this._dataSource);

  @override
  Future<Either<Failture, ProfileEntity>> getProfile(String userId) async {
    try {
      final result = await _dataSource.getProfile(userId);
      return Right(result.toEntity());
    } on Failture catch (failture) {
      return Left(failture);
    }
  }
}
