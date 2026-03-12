import 'package:dartz/dartz.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/domain/repository/auth_repository.dart';

class Register {
  final AuthRepository _repository;

  Register(this._repository);

  Future<Either<Failture, UserModel>> call({
    required String email,
    required String name,
    required String password,
    required String role,
  }) {
    return _repository.register(
      email: email,
      name: name,
      password: password,
      role: role,
    );
  }
}