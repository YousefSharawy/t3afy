import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/fcm_service.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/services/online_status_cubit.dart';
import 'package:t3afy/auth/data/mappers/user_mapper.dart';
import 'package:t3afy/auth/domain/entity/user_entity.dart';
import 'package:t3afy/auth/domain/use_cases/log_out_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/login_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/register_use_case.dart';
import 'package:t3afy/core/data/safe_emit.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> with SafeEmit<AuthState> {
  AuthCubit(this._logout, this._login, this._register, this._onlineStatusCubit)
    : super(const AuthState.initial());

  final Login _login;
  final Register _register;
  final Logout _logout;
  final OnlineStatusCubit _onlineStatusCubit;
  bool isVolunteer = false;
  String? gender;

  void toggleRole(bool role) {
    isVolunteer = role;
    emit(AuthState.roleChanged(isVolunteer));
  }

  void changeGender(String selectedGender) {
    gender = selectedGender;
    emit(AuthState.genderChanged(gender!));
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _login(email, password);
    await result.fold<Future<void>>(
      (failure) async => safeEmit(AuthState.error(failure.message)),
      (user) async {
        final entity = user.toEntity();
        await LocalAppStorage.saveUserSession(entity.role, entity.id);
        FcmService.saveTokenForUser(entity.id);
        await _onlineStatusCubit.reinitOnline();
        safeEmit(AuthState.success(entity));
      },
    );
  }

  Future<void> register({
    required String email,
    required String name,
    required String password,
    required String role,
    File? idFile,
  }) async {
    emit(const AuthState.loading());
    final result = await _register(
      email: email,
      name: name,
      password: password,
      role: role,
      idFile: idFile,
    );
    result.fold(
      (failure) => safeEmit(AuthState.error(failure.message)),
      (_) => safeEmit(const AuthState.registrationPending()),
    );
  }

  /// Presence and push token are cleared first because they need the stored
  /// user id; the cached data of this account goes before the session itself.
  Future<void> logout() async {
    emit(const AuthState.loading());
    final userId = LocalAppStorage.getUserId();
    await Future.wait([
      _onlineStatusCubit.goOffline(),
      if (userId != null) FcmService.clearTokenForUser(userId),
    ]);
    try {
      await _logout();
    } catch (_) {
      // Session is cleared locally regardless.
    }
    await LocalAppStorage.clearAllCache();
    await LocalAppStorage.clearUserSession();
    isVolunteer = false;
    gender = null;
    safeEmit(const AuthState.initial());
  }
}
