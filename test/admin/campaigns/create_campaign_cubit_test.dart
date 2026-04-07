import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';

import '../../helpers/fake_entities.dart';
import '../../helpers/hive_test_helper.dart';
import '../../helpers/mock_use_cases.dart';

void main() {
  late MockGetAllVolunteersUsecase mockGetAllVolunteers;
  late MockGetCampaignDetailUsecase mockGetDetail;
  late MockCreateCampaignUsecase mockCreate;
  late MockUpdateCampaignUsecase mockUpdate;

  CreateCampaignCubit buildCubit() => CreateCampaignCubit(
    mockGetAllVolunteers,
    mockGetDetail,
    mockCreate,
    mockUpdate,
  );

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    await setUpHive();
    mockGetAllVolunteers = MockGetAllVolunteersUsecase();
    mockGetDetail = MockGetCampaignDetailUsecase();
    mockCreate = MockCreateCampaignUsecase();
    mockUpdate = MockUpdateCampaignUsecase();
  });

  tearDown(() async {
    await tearDownHive();
  });

  group('CreateCampaignCubit', () {
    group('loadVolunteers', () {
      test('success → emits [loading, ready] with volunteer list', () async {
        final volunteers = [fakeCampaignVolunteer()];
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right(volunteers));

        final cubit = buildCubit();
        final states = <CreateCampaignState>[];
        // Subscribe BEFORE calling the method
        final sub = cubit.stream.listen(states.add);
        await cubit.loadVolunteers();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states[0], isA<CreateCampaignLoading>());
        expect(states[1], isA<CreateCampaignReady>());
        final ready = states[1] as CreateCampaignReady;
        expect(ready.volunteers.length, 1);
      });

      test('failure → emits [loading, error]', () async {
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل التحميل')));

        final cubit = buildCubit();
        final states = <CreateCampaignState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.loadVolunteers();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states[0], isA<CreateCampaignLoading>());
        expect(states[1], isA<CreateCampaignError>());
      });
    });

    group('loadForEdit', () {
      test('success → emits ready with taskData pre-filled', () async {
        final detail = fakeCampaignDetail(
          id: 'camp-1',
          title: 'حملة قديمة',
          timeStart: '09:00',
          timeEnd: '12:00',
        );
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right([fakeCampaignVolunteer()]));
        when(() => mockGetDetail(any())).thenAnswer((_) async => Right(detail));

        final cubit = buildCubit();
        final states = <CreateCampaignState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.loadForEdit('camp-1');
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        final ready = states.whereType<CreateCampaignReady>().last;
        expect(ready.taskData?['title'], 'حملة قديمة');
        expect(ready.timeStart?.hour, 9);
        expect(ready.timeEnd?.hour, 12);
      });
    });

    group('save (create)', () {
      test('valid data → emits [saving, saved]', () async {
        when(
          () => mockCreate(any()),
        ).thenAnswer((_) async => const Right('new-camp-id'));
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right([fakeCampaignVolunteer()]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();

        cubit.setDate(DateTime(2026, 3, 1));
        cubit.setTimeStart(const TimeOfDay(hour: 9, minute: 0));
        cubit.setTimeEnd(const TimeOfDay(hour: 12, minute: 0));

        final states = <CreateCampaignState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.save(
          title: 'حملة جديدة',
          description: 'وصف',
          locationName: 'مدرسة',
          locationAddress: null,
          supervisorName: 'أحمد',
          supervisorPhone: null,
          points: 50,
          notes: null,
          targetBeneficiaries: 100,
          objectiveTitles: ['هدف 1'],
          suppliesData: [],
          paperFiles: [],
        );
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states.any((s) => s is CreateCampaignSaving), isTrue);
        expect(states.any((s) => s is CreateCampaignSaved), isTrue);
      });

      test('missing date → emits validationError then back to ready', () async {
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right([fakeCampaignVolunteer()]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();
        // Do NOT set date

        final states = <CreateCampaignState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.save(
          title: 'حملة',
          description: null,
          locationName: null,
          locationAddress: null,
          supervisorName: null,
          supervisorPhone: null,
          points: 10,
          notes: null,
          targetBeneficiaries: 50,
          objectiveTitles: [],
          suppliesData: [],
          paperFiles: [],
        );
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states.any((s) => s is CreateCampaignValidationError), isTrue);
        // After validation error, cubit re-emits the ready state
        expect(states.last, isA<CreateCampaignReady>());
      });
    });

    group('save (edit)', () {
      test('with taskId → calls update, emits [saving, saved]', () async {
        when(
          () => mockUpdate(any(), any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right([fakeCampaignVolunteer()]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();
        cubit.setDate(DateTime(2026, 3, 1));
        cubit.setTimeStart(const TimeOfDay(hour: 9, minute: 0));
        cubit.setTimeEnd(const TimeOfDay(hour: 12, minute: 0));

        final states = <CreateCampaignState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.save(
          title: 'حملة معدّلة',
          description: null,
          locationName: 'مكان',
          locationAddress: null,
          supervisorName: null,
          supervisorPhone: null,
          points: 30,
          notes: null,
          targetBeneficiaries: 80,
          objectiveTitles: [],
          suppliesData: [],
          paperFiles: [],
          taskId: 'camp-1',
        );
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states.any((s) => s is CreateCampaignSaved), isTrue);
        verify(() => mockUpdate(any(), any())).called(1);
        verifyNever(() => mockCreate(any()));
      });
    });

    group('toggleVolunteer', () {
      test('toggle on → selectedIds contains id', () async {
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right([fakeCampaignVolunteer(id: 'vol-1')]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();
        cubit.toggleVolunteer('vol-1');

        final ready = cubit.state as CreateCampaignReady;
        expect(ready.selectedIds.contains('vol-1'), isTrue);
        cubit.close();
      });

      test('toggle off → selectedIds does not contain id', () async {
        when(
          () => mockGetAllVolunteers(),
        ).thenAnswer((_) async => Right([fakeCampaignVolunteer(id: 'vol-1')]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();
        cubit.toggleVolunteer('vol-1'); // on
        cubit.toggleVolunteer('vol-1'); // off

        final ready = cubit.state as CreateCampaignReady;
        expect(ready.selectedIds.contains('vol-1'), isFalse);
        cubit.close();
      });
    });

    group('setDate / setTimeStart / setTimeEnd', () {
      test('setDate emits ready with selectedDate updated', () async {
        when(() => mockGetAllVolunteers()).thenAnswer((_) async => Right([]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();

        final date = DateTime(2026, 6, 15);
        cubit.setDate(date);

        final ready = cubit.state as CreateCampaignReady;
        expect(ready.selectedDate, date);
        cubit.close();
      });

      test('setTimeStart emits ready with timeStart updated', () async {
        when(() => mockGetAllVolunteers()).thenAnswer((_) async => Right([]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();
        const time = TimeOfDay(hour: 8, minute: 30);
        cubit.setTimeStart(time);

        final ready = cubit.state as CreateCampaignReady;
        expect(ready.timeStart, time);
        cubit.close();
      });

      test('setTimeEnd emits ready with timeEnd updated', () async {
        when(() => mockGetAllVolunteers()).thenAnswer((_) async => Right([]));

        final cubit = buildCubit();
        await cubit.loadVolunteers();
        const time = TimeOfDay(hour: 16, minute: 0);
        cubit.setTimeEnd(time);

        final ready = cubit.state as CreateCampaignReady;
        expect(ready.timeEnd, time);
        cubit.close();
      });
    });
  });
}
