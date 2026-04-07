import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';
import 'package:t3afy/auth/domain/repository/auth_repository.dart';

class AuthImplRepository implements AuthRepository {
  final AuthRemoteDateSource _remoteDataSource;

  AuthImplRepository(this._remoteDataSource);

  @override
  Future<Either<Failture, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await _remoteDataSource.login(email, password);
      return Right(user);
    } on Failture catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failture, UserModel>> register({
    required String email,
    required String name,
    required String password,
    required String role,
    File? idFile,
  }) async {
    try {
      final user = await _remoteDataSource.register(
        email: email,
        name: name,
        password: password,
        role: role,
        idFile: idFile,
      );
      return Right(user);
    } on Failture catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failture, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on Failture catch (e) {
      return Left(e);
    }
  }
}
