

import 'package:t3afy/auth/data/models/user_model.dart';

abstract class AuthRemoteDateSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String name,
    required String password,
    required String role,
  });
  Future<void> logout();
}