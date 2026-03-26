import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';

import '../../../app/error_handler.dart';
import '../../../app/failture.dart';

class AuthImplRemoteDataSource implements AuthRemoteDateSource {
  SupabaseClient get _client => Supabase.instance.client;

  // ─────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Prototype Login: Query the public user profile directly
      final userResponse = await _client
          .from('users')
          .select('id,email,name,role,approval_status')
          .ilike('email', email)
          .single();

      final role = userResponse['role'] as String? ?? '';
      final approvalStatus = userResponse['approval_status'] as String? ?? '';

      // 2. Role / status guards
      if (role == 'volunteer' && approvalStatus == 'pending') {
        throw Failture(0, 'حسابك قيد المراجعة، يرجى انتظار موافقة الإدارة');
      }
      if (role == 'volunteer' && approvalStatus == 'rejected') {
        throw Failture(0, 'تم رفض طلبك، تواصل مع الإدارة');
      }
      if (role == 'suspended') {
        throw Failture(0, 'تم تعليق حسابك، تواصل مع الإدارة');
      }

      return UserModel.fromJson(userResponse);
    } catch (error) {
      if (error is Failture) rethrow;
      throw ErrorHandler.handle(error).failture;
    }
  }

  // ─────────────────────────────────────────────
  // REGISTER
  // ─────────────────────────────────────────────
  @override
  Future<UserModel> register({
    required String email,
    required String name,
    required String password,
    required String role,
    File? idFile,
  }) async {
    try {
      // ── STEP 1: Check for duplicate email in public.users ──────────────
      final existing = await _client
          .from('users')
          .select('id, role, approval_status')
          .ilike('email', email)
          .maybeSingle();

      if (existing != null) {
        final existingRole = existing['role'] as String? ?? '';
        final existingStatus = existing['approval_status'] as String? ?? '';
        if (existingRole == 'volunteer' && existingStatus == 'pending') {
          throw Failture(409, 'تم تقديم طلبك مسبقاً وهو قيد المراجعة');
        } else if (existingRole == 'volunteer') {
          throw Failture(409, 'هذا البريد مسجل بالفعل، يمكنك تسجيل الدخول');
        } else if (existingRole == 'suspended') {
          throw Failture(409, 'تم إيقاف هذا الحساب');
        } else {
          throw Failture(409, 'هذا البريد مسجل بالفعل');
        }
      }

      // ── STEP 2: Insert public profile row directly (Prototype Login) ────────────
      final insertResponse = await _client
          .from('users')
          .insert({
            'email': email,
            'name': name,
            'role': role,
            'approval_status': role == 'volunteer' ? 'pending' : 'approved',
          })
          .select('id,email,name,role,approval_status')
          .single();

      final userId = insertResponse['id'] as String;

      // ── STEP 3: Upload national ID image (only if provided) ─────────────
      if (idFile != null) {
        try {
          final bytes = await idFile.readAsBytes();

          // Build a clean, predictable storage path: userId/timestamp.ext
          final ext = idFile.path.split('.').last.toLowerCase();
          final safeExt = ['jpg', 'jpeg', 'png', 'pdf'].contains(ext)
              ? ext
              : 'jpg';
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final storagePath = '$userId/${timestamp}.$safeExt';

          final contentType = safeExt == 'pdf'
              ? 'application/pdf'
              : (safeExt == 'png' ? 'image/png' : 'image/jpeg');

          await _client.storage
              .from('volunteer-ids')
              .uploadBinary(
                storagePath,
                bytes,
                fileOptions: FileOptions(
                  contentType: contentType,
                  upsert: false,
                ),
              );

          final publicUrl = _client.storage
              .from('volunteer-ids')
              .getPublicUrl(storagePath);

          // ── STEP 4: Save URL back to the user's row ──────────────────────
          await _client
              .from('users')
              .update({'id_file_url': publicUrl})
              .eq('id', userId);
        } catch (e, stack) {
          print('--- UPLOAD FAILED ---');
          print(e);
          print(stack);
          // Upload failure should NOT silently succeed — surface the error.
          throw Failture(
            400,
            'تعذر رفع صورة الهوية. تأكد من أن حجم الصورة أقل من 5 MB وصيغتها صحيحة.',
          );
        }
      }

      return UserModel.fromJson(insertResponse);
    } catch (error) {
      if (error is Failture) rethrow;
      throw ErrorHandler.handle(error).failture;
    }
  }

  // ─────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────
  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw ErrorHandler.handle(error).failture;
    }
  }
}