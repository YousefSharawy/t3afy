import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';

abstract class AdminProfileRemoteDatasource {
  Future<AdminProfileEntity> getProfile(
    String userId, {
    bool forceRefresh = false,
  });
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  });
}
