

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';

import '../../../app/error_handler.dart';

class AuthImplRemoteDataSource implements AuthRemoteDateSource {
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userResponse = await Supabase.instance.client
          .from('users')
          .select('id,email,name,role')
          .ilike('email', email)
          .single();
      return UserModel.fromJson(userResponse);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String name,
    required String password,
    required String role,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .insert({
            'email': email,
            'name': name,
            'role': role,
          })
          .select('id,email,name,role')
          .single();
      return UserModel.fromJson(response);
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (error) {
      if (error is PostgrestException) {
      } else if (error is AuthException) {}
      throw ErrorHandler.handle(error).failture;
    }
  }
}