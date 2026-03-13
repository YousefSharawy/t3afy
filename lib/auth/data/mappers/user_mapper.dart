import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/domain/entity/user_entity.dart';

extension UserMapper on UserModel {
  UserEntity toEntity() => UserEntity(email: email, name: name, role: role, id: id);
}
