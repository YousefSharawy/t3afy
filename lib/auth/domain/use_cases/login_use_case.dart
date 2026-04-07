import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/domain/repository/auth_repository.dart';

class Login {
  final AuthRepository authRepository;
  Login(this.authRepository);

  Future<Either<Failture, UserModel>> call(String email, String password) =>
      authRepository.login(email, password);
}
