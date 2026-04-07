import 'package:t3afy/auth/domain/repository/auth_repository.dart';

class Logout {
  final AuthRepository _repository;
  Logout(this._repository);

  Future<void> call() async {
    await _repository.logout();
  }
}
