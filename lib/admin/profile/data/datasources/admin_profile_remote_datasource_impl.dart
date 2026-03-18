import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/data/datasources/admin_profile_remote_datasource.dart';

class AdminProfileRemoteDatasourceImpl implements AdminProfileRemoteDatasource {
  final _client = Supabase.instance.client;

  @override
  Future<AdminProfileEntity> getProfile(String userId) async {
    try {
      final cacheKey = 'admin_profile_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        final data = Map<String, dynamic>.from(cached as Map);
        return AdminProfileEntity(
          id: data['id'] as String,
          name: data['name'] as String? ?? '',
          email: data['email'] as String? ?? '',
          phone: data['phone'] as String?,
          avatarUrl: data['avatar_url'] as String?,
          role: data['role'] as String? ?? 'admin',
          joinedAt: data['joined_at'] != null
              ? DateTime.tryParse(data['joined_at'] as String)
              : null,
        );
      }

      final data = await _client
          .from('users')
          .select('id, name, email, phone, avatar_url, role, joined_at')
          .eq('id', userId)
          .single();
      await LocalAppStorage.setCache(cacheKey, data,
          ttl: const Duration(minutes: 10));
      return AdminProfileEntity(
        id: data['id'] as String,
        name: data['name'] as String? ?? '',
        email: data['email'] as String? ?? '',
        phone: data['phone'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        role: data['role'] as String? ?? 'admin',
        joinedAt: data['joined_at'] != null
            ? DateTime.tryParse(data['joined_at'] as String)
            : null,
      );
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String? phone,
    required String email,
  }) async {
    try {
      await _client
          .from('users')
          .update({'name': name, 'phone': phone, 'email': email})
          .eq('id', userId);
      await LocalAppStorage.invalidateCache('admin_profile_$userId');
    } catch (e) {
      throw ErrorHandler.handle(e).failture;
    }
  }
}
