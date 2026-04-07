import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/error_handler.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/volunteer/profile/data/model/profile_model.dart';
import 'package:t3afy/volunteer/profile/data/source/profile_data_source.dart';

class ProfileImplRemoteDataSource implements ProfileRemoteDataSource {
  final _client = Supabase.instance.client;

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final cacheKey = 'vol_profile_$userId';
      final cached = LocalAppStorage.getCache(cacheKey);
      if (cached != null) {
        return ProfileModel.fromJson(Map<String, dynamic>.from(cached as Map));
      }

      final response = await _client
          .from('users')
          .select(
            'id, name, email, phone, avatar_url, region, qualification, level, level_title, rating, total_hours, total_tasks, places_visited, total_points, joined_at, id_file_url',
          )
          .eq('id', userId)
          .single();
      await LocalAppStorage.setCache(
        cacheKey,
        response,
        ttl: const Duration(minutes: 1),
      );
      return ProfileModel.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}
