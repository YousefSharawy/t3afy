// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:t3afy/app/failture.dart';
// import 'package:t3afy/auth/data/models/user_model.dart';
// import 'package:t3afy/auth/domain/entity/user_entity.dart';
// import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

// import '../helpers/hive_test_helper.dart';
// import '../helpers/mock_use_cases.dart';

// bool _isLoading(AuthState s) =>
//     s.maybeWhen(loading: () => true, orElse: () => false);
// bool _isInitial(AuthState s) =>
//     s.maybeWhen(initial: () => true, orElse: () => false);
// bool _isRegistrationPending(AuthState s) =>
//     s.maybeWhen(registrationPending: () => true, orElse: () => false);
// String? _errorMessage(AuthState s) =>
//     s.maybeWhen(error: (m) => m, orElse: () => null);
// UserEntity? _successUser(AuthState s) =>
//     s.maybeWhen(success: (u) => u, orElse: () => null);
// bool? _roleChangedValue(AuthState s) =>
//     s.maybeWhen(roleChanged: (v) => v, orElse: () => null);
// String? _genderChangedValue(AuthState s) =>
//     s.maybeWhen(genderChanged: (g) => g, orElse: () => null);

// void main() {
//   late MockLogin mockLogin;
//   late MockRegister mockRegister;
//   late MockLogout mockLogout;

//   setUpAll(() {
//     registerFallbackValue('');
//   });

//   // Each test gets a fresh Hive box so saveUserSession never fails.
//   setUp(() async {
//     await setUpHive();
//     mockLogin = MockLogin();
//     mockRegister = MockRegister();
//     mockLogout = MockLogout();
//   });

//   tearDown(() async {
//     await tearDownHive();
//   });

//   AuthCubit buildCubit() => AuthCubit(mockLogout, mockLogin, mockRegister,);

//   UserModel fakeUserModel({String role = 'admin'}) => UserModel(
//         id: 'user-1',
//         email: 'test@test.com',
//         name: 'يوسف',
//         role: role,
//       );

//   group('AuthCubit', () {
//     group('login', () {
//       test('emits [loading, success] for admin role', () async {
//         when(() => mockLogin(any(), any()))
//             .thenAnswer((_) async => Right(fakeUserModel(role: 'admin')));

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.login('test@test.com', 'password');
//         await Future<void>.delayed(const Duration(milliseconds: 10));
//         await sub.cancel();
//         await cubit.close();

//         expect(states.length, 2);
//         expect(_isLoading(states[0]), isTrue);
//         expect(_successUser(states[1])?.role, 'admin');
//       });

//       test('emits [loading, success] for volunteer role', () async {
//         when(() => mockLogin(any(), any()))
//             .thenAnswer((_) async => Right(fakeUserModel(role: 'volunteer')));

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.login('vol@test.com', 'password');
//         await Future<void>.delayed(const Duration(milliseconds: 10));
//         await sub.cancel();
//         await cubit.close();

//         expect(states.length, 2);
//         expect(_isLoading(states[0]), isTrue);
//         expect(_successUser(states[1])?.role, 'volunteer');
//       });

//       test('emits [loading, error] on failure', () async {
//         when(() => mockLogin(any(), any()))
//             .thenAnswer((_) async => Left(Failture(0, 'خطأ في الاتصال')));

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.login('bad@test.com', 'wrong');
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.length, 2);
//         expect(_isLoading(states[0]), isTrue);
//         expect(_errorMessage(states[1]), 'خطأ في الاتصال');
//       });
//     });

//     group('register', () {
//       test('emits [loading, registrationPending] — no session saved', () async {
//         when(() => mockRegister(
//               email: any(named: 'email'),
//               name: any(named: 'name'),
//               password: any(named: 'password'),
//               role: any(named: 'role'),
//             )).thenAnswer((_) async => Right(fakeUserModel()));

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.register(
//           email: 'new@test.com',
//           name: 'محمد',
//           password: 'pass123',
//           role: 'volunteer',
//         );
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.length, 2);
//         expect(_isLoading(states[0]), isTrue);
//         expect(_isRegistrationPending(states[1]), isTrue);
//         expect(_successUser(states[1]), isNull);
//       });

//       test('emits [loading, error] on failure', () async {
//         when(() => mockRegister(
//               email: any(named: 'email'),
//               name: any(named: 'name'),
//               password: any(named: 'password'),
//               role: any(named: 'role'),
//             )).thenAnswer((_) async => Left(Failture(0, 'البريد مستخدم')));

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.register(
//           email: 'dup@test.com',
//           name: 'علي',
//           password: 'pass123',
//           role: 'volunteer',
//         );
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.length, 2);
//         expect(_isLoading(states[0]), isTrue);
//         expect(_errorMessage(states[1]), 'البريد مستخدم');
//       });
//     });

//     group('logout', () {
//       test('emits [loading, initial]', () async {
//         when(() => mockLogout()).thenAnswer((_) async {});

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.logout();
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.length, 2);
//         expect(_isLoading(states[0]), isTrue);
//         expect(_isInitial(states[1]), isTrue);
//       });

//       test('still emits initial even if logout throws', () async {
//         when(() => mockLogout()).thenThrow(Exception('network error'));

//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         await cubit.logout();
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(_isInitial(states.last), isTrue);
//       });
//     });

//     group('toggleRole', () {
//       test('emits roleChanged(true)', () async {
//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         cubit.toggleRole(true);
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.isNotEmpty, isTrue);
//         expect(_roleChangedValue(states.first), true);
//       });

//       test('emits roleChanged(false)', () async {
//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         cubit.toggleRole(false);
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.isNotEmpty, isTrue);
//         expect(_roleChangedValue(states.first), false);
//       });
//     });

//     group('changeGender', () {
//       test('emits genderChanged with given gender', () async {
//         final cubit = buildCubit();
//         final states = <AuthState>[];
//         final sub = cubit.stream.listen(states.add);
//         cubit.changeGender('male');
//         await Future<void>.delayed(Duration.zero);
//         await sub.cancel();
//         await cubit.close();

//         expect(states.isNotEmpty, isTrue);
//         expect(_genderChangedValue(states.first), 'male');
//       });
//     });
//   });
// }
