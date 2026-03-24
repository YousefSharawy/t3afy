

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';

import '../../../app/error_handler.dart';
import '../../../app/failture.dart';

class AuthImplRemoteDataSource implements AuthRemoteDateSource {
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userResponse = await Supabase.instance.client
          .from('users')
          .select('id,email,name,role')
          .ilike('email', email)
          .single();
      final role = userResponse['role'] as String? ?? '';
      if (role == 'user') {
        throw Failture(0, 'حسابك قيد المراجعة، يرجى انتظار موافقة الإدارة');
      }
      if (role == 'suspended') {
        throw Failture(0, 'تم تعليق حسابك، تواصل مع الإدارة');
      }
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