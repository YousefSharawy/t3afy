import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/app/app_const.dart';
import 'package:t3afy/auth/data/models/user_model.dart';
import 'package:t3afy/auth/data/source/auth_remote_date_source.dart';

import '../../../app/error_handler.dart';
import '../../../app/failture.dart';

class AuthImplRemoteDataSource implements AuthRemoteDateSource {
  SupabaseClient get _client => Supabase.instance.client;

  /// Case-insensitive exact match: `_` and `%` (common in emails, e.g.
  /// john_doe@…) are LIKE wildcards, so they are escaped.
  static String _likeLiteral(String value) => value
      .trim()
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');

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
          .ilike('email', _likeLiteral(email))
          .maybeSingle();
      if (userResponse == null) {
        throw Failture(404, 'لا يوجد حساب بهذا البريد الإلكتروني');
      }

      final role = userResponse['role'] as String? ?? '';
      final approvalStatus = userResponse['approval_status'] as String? ?? '';

      // 2. Role / status guards. The role is the source of truth: a new
      // registration is stored as 'user' until an admin approves it (which
      // only flips the role to 'volunteer'), and volunteers added by an admin
      // keep the column default approval_status 'pending'.
      if (approvalStatus == 'rejected') {
        throw Failture(0, 'تم رفض طلبك، تواصل مع الإدارة');
      }
      if (role == 'user') {
        throw Failture(0, 'حسابك قيد المراجعة، يرجى انتظار موافقة الإدارة');
      }
      if (role == 'suspended') {
        throw Failture(0, 'تم تعليق حسابك، تواصل مع الإدارة');
      }
      if (role != 'volunteer' && role != 'admin') {
        throw Failture(0, 'هذا الحساب غير مفعّل، تواصل مع الإدارة');
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
    String? gender,
    File? idFile,
  }) async {
    try {
      // ── STEP 1: Check for duplicate email in public.users ──────────────
      final existing = await _client
          .from('users')
          .select('id, role')
          .ilike('email', _likeLiteral(email))
          .maybeSingle();

      if (existing != null) {
        final existingRole = existing['role'] as String? ?? '';
        if (existingRole == 'user') {
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
            'gender': ?gender,
            'approval_status': role == 'admin' ? 'approved' : 'pending',
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
          final storagePath = '$userId/$timestamp.$safeExt';

          final contentType = safeExt == 'pdf'
              ? 'application/pdf'
              : (safeExt == 'png' ? 'image/png' : 'image/jpeg');

          await _client.storage
              .from(StorageBuckets.volunteerIds)
              .uploadBinary(
                storagePath,
                bytes,
                fileOptions: FileOptions(
                  contentType: contentType,
                  upsert: false,
                ),
              );

          final publicUrl = _client.storage
              .from(StorageBuckets.volunteerIds)
              .getPublicUrl(storagePath);

          // ── STEP 4: Save URL back to the user's row ──────────────────────
          await _client
              .from('users')
              .update({'id_file_url': publicUrl})
              .eq('id', userId);
        } catch (e, stack) {
          // Roll back the profile row so the same email can register again
          // instead of hitting "already registered" with no ID on file.
          try {
            await _client.from('users').delete().eq('id', userId);
          } catch (_) {}
          if (kDebugMode) {
            debugPrint('--- UPLOAD FAILED ---');
            debugPrint(e.toString());
            debugPrint(stack.toString());
          }
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
