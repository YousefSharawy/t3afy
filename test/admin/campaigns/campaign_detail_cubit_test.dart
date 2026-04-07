import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';

import '../../helpers/fake_entities.dart';
import '../../helpers/mock_use_cases.dart';

void main() {
  late MockGetCampaignDetailUsecase mockGetDetail;
  late MockAssignVolunteerUsecase mockAssignVolunteer;
  late MockRemoveVolunteerUsecase mockRemoveVolunteer;
  late MockSendTeamAlertUsecase mockSendAlert;
  late MockDeleteCampaignUsecase mockDeleteCampaign;
  late MockUpdateCampaignUsecase mockUpdateCampaign;
  late MockGetUnassignedVolunteersUsecase mockGetUnassigned;

  CampaignDetailCubit buildCubit() => CampaignDetailCubit(
    mockGetDetail,
    mockAssignVolunteer,
    mockRemoveVolunteer,
    mockSendAlert,
    mockDeleteCampaign,
    mockUpdateCampaign,
    mockGetUnassigned,
  );

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    mockGetDetail = MockGetCampaignDetailUsecase();
    mockAssignVolunteer = MockAssignVolunteerUsecase();
    mockRemoveVolunteer = MockRemoveVolunteerUsecase();
    mockSendAlert = MockSendTeamAlertUsecase();
    mockDeleteCampaign = MockDeleteCampaignUsecase();
    mockUpdateCampaign = MockUpdateCampaignUsecase();
    mockGetUnassigned = MockGetUnassignedVolunteersUsecase();
  });

  group('CampaignDetailCubit', () {
    group('assignVolunteers', () {
      test('success → refreshes detail and returns true', () async {
        final detail = fakeCampaignDetail();
        when(
          () => mockAssignVolunteer(
            taskId: any(named: 'taskId'),
            userIds: any(named: 'userIds'),
            adminId: any(named: 'adminId'),
          ),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetDetail(any())).thenAnswer((_) async => Right(detail));

        final cubit = buildCubit();
        final states = <CampaignDetailState>[];
        final sub = cubit.stream.listen(states.add);

        final result = await cubit.assignVolunteers(
          taskId: 'camp-1',
          userIds: ['vol-1'],
          adminId: 'admin-1',
        );

        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(result, isTrue);
        expect(states.any((s) => s is CampaignDetailLoaded), isTrue);
      });

      test(
        'failure → emits CampaignDetailActionError and returns false',
        () async {
          when(
            () => mockAssignVolunteer(
              taskId: any(named: 'taskId'),
              userIds: any(named: 'userIds'),
              adminId: any(named: 'adminId'),
            ),
          ).thenAnswer((_) async => Left(Failture(0, 'فشل التعيين')));

          final cubit = buildCubit();
          final states = <CampaignDetailState>[];
          final sub = cubit.stream.listen(states.add);

          final result = await cubit.assignVolunteers(
            taskId: 'camp-1',
            userIds: ['vol-1'],
            adminId: 'admin-1',
          );

          await Future<void>.delayed(Duration.zero);
          await sub.cancel();
          cubit.close();

          expect(result, isFalse);
          expect(states.any((s) => s is CampaignDetailActionError), isTrue);
          final err = states.whereType<CampaignDetailActionError>().first;
          expect(err.message, 'فشل التعيين');
        },
      );
    });

    group('deleteCampaign', () {
      test('success → emits CampaignDetailDeleted and returns true', () async {
        when(
          () => mockDeleteCampaign(any()),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        final states = <CampaignDetailState>[];
        final sub = cubit.stream.listen(states.add);

        final result = await cubit.deleteCampaign('camp-1');

        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(result, isTrue);
        expect(states.any((s) => s is CampaignDetailDeleted), isTrue);
      });

      test(
        'failure → emits CampaignDetailActionError and returns false',
        () async {
          when(
            () => mockDeleteCampaign(any()),
          ).thenAnswer((_) async => Left(Failture(0, 'لا يمكن الحذف')));

          final cubit = buildCubit();
          final states = <CampaignDetailState>[];
          final sub = cubit.stream.listen(states.add);

          final result = await cubit.deleteCampaign('camp-1');

          await Future<void>.delayed(Duration.zero);
          await sub.cancel();
          cubit.close();

          expect(result, isFalse);
          expect(states.any((s) => s is CampaignDetailActionError), isTrue);
        },
      );
    });

    group('sendAlert', () {
      test('success → emits [saving, alertSent]', () async {
        when(
          () => mockSendAlert(
            taskId: any(named: 'taskId'),
            adminId: any(named: 'adminId'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            volunteerIds: any(named: 'volunteerIds'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        final states = <CampaignDetailState>[];
        final sub = cubit.stream.listen(states.add);

        await cubit.sendAlert(
          taskId: 'camp-1',
          adminId: 'admin-1',
          title: 'تنبيه',
          body: 'رسالة',
          volunteerIds: ['vol-1'],
        );

        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states[0], isA<CampaignDetailSaving>());
        expect(states[1], isA<CampaignDetailAlertSent>());
      });

      test('failure → emits [saving, actionError]', () async {
        when(
          () => mockSendAlert(
            taskId: any(named: 'taskId'),
            adminId: any(named: 'adminId'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            volunteerIds: any(named: 'volunteerIds'),
          ),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل الإرسال')));

        final cubit = buildCubit();
        final states = <CampaignDetailState>[];
        final sub = cubit.stream.listen(states.add);

        await cubit.sendAlert(
          taskId: 'camp-1',
          adminId: 'admin-1',
          title: 'تنبيه',
          body: 'رسالة',
          volunteerIds: ['vol-1'],
        );

        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states[0], isA<CampaignDetailSaving>());
        expect(states[1], isA<CampaignDetailActionError>());
      });
    });

    group('removeVolunteer', () {
      test('success on loaded state → member removed optimistically', () async {
        final member = fakeCampaignMember(id: 'vol-1');
        final detail = fakeCampaignDetail(members: [member]);

        when(() => mockGetDetail(any())).thenAnswer((_) async => Right(detail));
        when(
          () => mockRemoveVolunteer(
            taskId: any(named: 'taskId'),
            userId: any(named: 'userId'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        final states = <CampaignDetailState>[];
        final sub = cubit.stream.listen(states.add);

        await cubit.removeVolunteer(taskId: 'camp-1', userId: 'vol-1');

        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states.whereType<CampaignDetailActionError>(), isEmpty);
      });

      test('failure → emits CampaignDetailActionError', () async {
        when(
          () => mockRemoveVolunteer(
            taskId: any(named: 'taskId'),
            userId: any(named: 'userId'),
          ),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل الحذف')));

        final cubit = buildCubit();
        final states = <CampaignDetailState>[];
        final sub = cubit.stream.listen(states.add);

        await cubit.removeVolunteer(taskId: 'camp-1', userId: 'vol-1');

        await Future<void>.delayed(Duration.zero);
        await sub.cancel();
        cubit.close();

        expect(states.any((s) => s is CampaignDetailActionError), isTrue);
      });
    });

    group('getUnassignedVolunteers', () {
      test('success → returns volunteer list', () async {
        final volunteers = [fakeCampaignVolunteer()];
        when(
          () => mockGetUnassigned(any()),
        ).thenAnswer((_) async => Right(volunteers));

        final cubit = buildCubit();
        final result = await cubit.getUnassignedVolunteers('camp-1');
        cubit.close();

        expect(result.length, 1);
        expect(result.first.id, 'vol-1');
      });

      test('failure → returns empty list', () async {
        when(
          () => mockGetUnassigned(any()),
        ).thenAnswer((_) async => Left(Failture(0, 'error')));

        final cubit = buildCubit();
        final result = await cubit.getUnassignedVolunteers('camp-1');
        cubit.close();

        expect(result, isEmpty);
      });
    });
  });
}
