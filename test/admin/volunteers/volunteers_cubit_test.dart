import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';

import '../../helpers/fake_entities.dart';
import '../../helpers/mock_repositories.dart';
import '../../helpers/mock_use_cases.dart';

void main() {
  late MockGetVolunteersUsecase mockGetVolunteers;
  late MockVolunteersRepo mockRepo;
  late MockAddVolunteerUsecase mockAddVolunteer;
  late MockGetPendingUsersUsecase mockGetPending;

  VolunteersCubit buildCubit() => VolunteersCubit(
    mockGetVolunteers,
    mockRepo,
    mockAddVolunteer,
    mockGetPending,
  );

  setUp(() {
    mockGetVolunteers = MockGetVolunteersUsecase();
    mockRepo = MockVolunteersRepo();
    mockAddVolunteer = MockAddVolunteerUsecase();
    mockGetPending = MockGetPendingUsersUsecase();

    // Constructor always calls these — stub them
    when(() => mockRepo.subscribeRealtime(any())).thenReturn(null);
    when(() => mockRepo.disposeRealtime()).thenReturn(null);
  });

  bool isError(VolunteersState s) =>
      s.maybeWhen(error: (_) => true, orElse: () => false);

  group('VolunteersCubit', () {
    group('loadVolunteers', () {
      test('success → final state is loaded with volunteer list', () async {
        final volunteers = [fakeAdminVolunteer()];
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right(volunteers));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        final count = cubit.state.maybeWhen(
          loaded: (vols, filter, searchQuery, pendingUsers, pendingLoading) =>
              vols.length,
          orElse: () => -1,
        );
        expect(count, 1);
        cubit.close();
      });

      test('failure → final state is error', () async {
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Left(Failture(0, 'خطأ')));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        expect(isError(cubit.state), isTrue);
        cubit.close();
      });
    });

    group('setFilter', () {
      test('updates filter field in loaded state', () async {
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right([fakeAdminVolunteer()]));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        cubit.setFilter('active');

        final filter = cubit.state.maybeWhen(
          loaded: (vols, filter, searchQuery, pendingUsers, pendingLoading) =>
              filter,
          orElse: () => null,
        );
        expect(filter, 'active');
        cubit.close();
      });

      test('does nothing when state is not loaded', () async {
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Left(Failture(0, 'خطأ')));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);
        // State is error, setFilter should be a no-op
        cubit.setFilter('active');
        expect(isError(cubit.state), isTrue);
        cubit.close();
      });
    });

    group('setSearchQuery', () {
      test('updates searchQuery in loaded state', () async {
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right([fakeAdminVolunteer()]));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        cubit.setSearchQuery('يوسف');

        final query = cubit.state.maybeWhen(
          loaded: (vols, filter, searchQuery, pendingUsers, pendingLoading) =>
              searchQuery,
          orElse: () => null,
        );
        expect(query, 'يوسف');
        cubit.close();
      });
    });

    group('addVolunteer', () {
      test('success → reloads and final state is loaded', () async {
        final volunteers = [fakeAdminVolunteer()];
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right(volunteers));
        when(
          () => mockAddVolunteer(
            name: any(named: 'name'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            region: any(named: 'region'),
            qualification: any(named: 'qualification'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        await cubit.addVolunteer(name: 'جديد', email: 'new@test.com');
        await Future<void>.delayed(Duration.zero);

        final isLoaded = cubit.state.maybeWhen(
          loaded: (vols, f, sq, pu, pl) => true,
          orElse: () => false,
        );
        expect(isLoaded, isTrue);
        cubit.close();
      });

      test('failure → emits error', () async {
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right([fakeAdminVolunteer()]));
        when(
          () => mockAddVolunteer(
            name: any(named: 'name'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            region: any(named: 'region'),
            qualification: any(named: 'qualification'),
          ),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل الإضافة')));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        await cubit.addVolunteer(name: 'خطأ', email: 'err@test.com');

        expect(isError(cubit.state), isTrue);
        cubit.close();
      });
    });

    group('loadPendingUsers', () {
      test('success → pendingUsers populated in loaded state', () async {
        final volunteers = [fakeAdminVolunteer()];
        final pending = [fakeAdminVolunteer(id: 'pending-1', role: 'user')];
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right(volunteers));
        when(() => mockGetPending()).thenAnswer((_) async => Right(pending));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        await cubit.loadPendingUsers();

        final pendingUsers = cubit.state.maybeWhen(
          loaded: (vols, filter, searchQuery, pendingUsers, pendingLoading) =>
              pendingUsers,
          orElse: () => null,
        );
        expect(pendingUsers?.length, 1);
        expect(pendingUsers?.first.role, 'user');
        cubit.close();
      });

      test('failure → keeps pendingLoading false', () async {
        when(
          () => mockGetVolunteers(),
        ).thenAnswer((_) async => Right([fakeAdminVolunteer()]));
        when(
          () => mockGetPending(),
        ).thenAnswer((_) async => Left(Failture(0, 'error')));

        final cubit = buildCubit();
        await Future<void>.delayed(Duration.zero);

        await cubit.loadPendingUsers();

        final loading = cubit.state.maybeWhen(
          loaded: (vols, filter, searchQuery, pendingUsers, pendingLoading) =>
              pendingLoading,
          orElse: () => null,
        );
        expect(loading, isFalse);
        cubit.close();
      });
    });
  });
}
