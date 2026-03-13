import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/auth/data/mappers/user_mapper.dart';
import 'package:t3afy/auth/domain/entity/user_entity.dart';
import 'package:t3afy/auth/domain/use_cases/login_use_case.dart';
import 'package:t3afy/auth/domain/use_cases/register_use_case.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login, this._register) : super(const AuthState.initial());

  final Login _login;
  final Register _register;
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
    result.fold((failure) => emit(AuthState.error(failure.message)), (user) {
      final entity = user.toEntity();
      LocalAppStorage.saveUserSession(entity.role,entity.id);
      emit(AuthState.success(entity));
    });
  }

  Future<void> register({
    required String email,
    required String name,
    required String password,
    required String role,
  }) async {
    emit(const AuthState.loading());
    final result = await _register(
      email: email,
      name: name,
      password: password,
      role: role,
    );
    result.fold((failure) => emit(AuthState.error(failure.message)), (user) {
      final entity = user.toEntity();
      LocalAppStorage.saveUserSession(entity.role,entity.id);
      emit(AuthState.success(entity));
    });
  }
}
