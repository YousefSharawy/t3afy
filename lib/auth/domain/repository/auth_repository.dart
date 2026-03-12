import 'package:dartz/dartz.dart';
import 'package:t3afy/auth/data/models/user_model.dart';

import '../../../app/failture.dart';

abstract class AuthRepository {
  Future<Either<Failture, UserModel>> login(String email, String password);
  Future<Either<Failture, UserModel>> register({
    required String email,
    required String name,
    required String password,
    required String role,
  });
  Future<Either<Failture, void>> logout();
}