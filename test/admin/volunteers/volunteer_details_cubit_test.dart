import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:t3afy/app/failture.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';

import '../../helpers/fake_entities.dart';
import '../../helpers/mock_use_cases.dart';

void main() {
  late MockGetVolunteerDetailsUsecase mockGetDetails;
  late MockDeleteVolunteerUsecase mockDelete;
  late MockApproveVolunteerUsecase mockApprove;
  late MockGetAvailableTasksUsecase mockGetTasks;
  late MockAssignTaskUsecase mockAssignTask;
  late MockSendDirectMessageUsecase mockSendMessage;
  late MockAddRatingUsecase mockAddRating;
  late MockUpgradeLevelUsecase mockUpgradeLevel;
  late MockEditVolunteerDataUsecase mockEditData;
  late MockSuspendAccountUsecase mockSuspend;
  late MockAssignCustomTaskUsecase mockAssignCustom;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  VolunteerDetailsCubit buildCubit() => VolunteerDetailsCubit(
    mockGetDetails,
    mockDelete,
    mockApprove,
    mockGetTasks,
    mockAssignTask,
    mockSendMessage,
    mockAddRating,
    mockUpgradeLevel,
    mockEditData,
    mockSuspend,
    mockAssignCustom,
  );

  setUp(() {
    mockGetDetails = MockGetVolunteerDetailsUsecase();
    mockDelete = MockDeleteVolunteerUsecase();
    mockApprove = MockApproveVolunteerUsecase();
    mockGetTasks = MockGetAvailableTasksUsecase();
    mockAssignTask = MockAssignTaskUsecase();
    mockSendMessage = MockSendDirectMessageUsecase();
    mockAddRating = MockAddRatingUsecase();
    mockUpgradeLevel = MockUpgradeLevelUsecase();
    mockEditData = MockEditVolunteerDataUsecase();
    mockSuspend = MockSuspendAccountUsecase();
    mockAssignCustom = MockAssignCustomTaskUsecase();
  });

  group('VolunteerDetailsCubit', () {
    group('load', () {
      test('success → emits [loading, loaded]', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));

        final cubit = buildCubit();
        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.load('vol-1');
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states[0], isA<VolunteerDetailsLoading>());
        expect(states[1], isA<VolunteerDetailsLoaded>());
        expect((states[1] as VolunteerDetailsLoaded).details.id, 'vol-1');
        cubit.close();
      });

      test('failure → emits [loading, error]', () async {
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Left(Failture(0, 'خطأ')));

        final cubit = buildCubit();
        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.load('vol-1');
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states[0], isA<VolunteerDetailsLoading>());
        expect(states[1], isA<VolunteerDetailsError>());
        cubit.close();
      });
    });

    group('approveVolunteer', () {
      test('isPending=true → emits actionSuccess with message', () async {
        final details = fakeVolunteerDetails(role: 'user');
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockApprove(any()),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.approveVolunteer('vol-1', isPending: true);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionSuccess), isTrue);
        final success = states.whereType<VolunteerDetailsActionSuccess>().first;
        expect(success.message, 'تم قبول المتطوع');
        cubit.close();
      });

      test('failure → emits actionError', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockApprove(any()),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل القبول')));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.approveVolunteer('vol-1', isPending: true);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionError), isTrue);
        cubit.close();
      });
    });

    group('deleteVolunteer', () {
      test('success → emits [deleting, deleted]', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockDelete(any()),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.deleteVolunteer('vol-1');
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states[0], isA<VolunteerDetailsDeleting>());
        expect(states[1], isA<VolunteerDetailsDeleted>());
        cubit.close();
      });

      test('failure → emits actionError', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockDelete(any()),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل الحذف')));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.deleteVolunteer('vol-1');
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionError), isTrue);
        cubit.close();
      });
    });

    group('rejectVolunteer', () {
      test('success → emits actionSuccess', () async {
        final details = fakeVolunteerDetails(role: 'user');
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockDelete(any()),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.rejectVolunteer('vol-1');
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionSuccess), isTrue);
        final success = states.whereType<VolunteerDetailsActionSuccess>().first;
        expect(success.message, 'تم رفض الطلب');
        cubit.close();
      });
    });

    group('suspendAccount', () {
      test('success → emits suspended state', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockSuspend(any()),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.suspendAccount();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsSuspended), isTrue);
        cubit.close();
      });

      test('failure → emits actionError', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockSuspend(any()),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل التعليق')));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.suspendAccount();
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionError), isTrue);
        cubit.close();
      });
    });

    group('sendDirectMessage', () {
      test('success → emits actionSuccess', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockSendMessage(
            adminId: any(named: 'adminId'),
            volunteerId: any(named: 'volunteerId'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.sendDirectMessage(
          adminId: 'admin-1',
          title: 'رسالة',
          body: 'نص الرسالة',
        );
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionSuccess), isTrue);
        cubit.close();
      });

      test('failure → emits actionError', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockSendMessage(
            adminId: any(named: 'adminId'),
            volunteerId: any(named: 'volunteerId'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل الإرسال')));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.sendDirectMessage(
          adminId: 'admin-1',
          title: 'رسالة',
          body: 'نص',
        );
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionError), isTrue);
        cubit.close();
      });
    });

    group('addRating', () {
      test('success → emits actionSuccess with updated rating', () async {
        final details = fakeVolunteerDetails(rating: 3.0);
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockAddRating(
            adminId: any(named: 'adminId'),
            volunteerId: any(named: 'volunteerId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.addRating(adminId: 'admin-1', rating: 5);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        final success = states.whereType<VolunteerDetailsActionSuccess>().first;
        expect(success.details.rating, 5.0);
        cubit.close();
      });

      test('failure → emits actionError', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockAddRating(
            adminId: any(named: 'adminId'),
            volunteerId: any(named: 'volunteerId'),
            rating: any(named: 'rating'),
            comment: any(named: 'comment'),
          ),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل التقييم')));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.addRating(adminId: 'admin-1', rating: 4);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionError), isTrue);
        cubit.close();
      });
    });

    group('upgradeLevel', () {
      test(
        'success → emits actionSuccess with updated level and levelTitle',
        () async {
          final details = fakeVolunteerDetails(
            level: 2,
            levelTitle: 'متطوع مبتدئ',
          );
          when(
            () => mockGetDetails(any()),
          ).thenAnswer((_) async => Right(details));
          when(
            () => mockUpgradeLevel(
              volunteerId: any(named: 'volunteerId'),
              level: any(named: 'level'),
              levelTitle: any(named: 'levelTitle'),
            ),
          ).thenAnswer((_) async => const Right(null));

          final cubit = buildCubit();
          await cubit.load('vol-1');

          final states = <VolunteerDetailsState>[];
          final sub = cubit.stream.listen(states.add);
          await cubit.upgradeLevel(level: 4, levelTitle: 'متطوع نشيط');
          await Future<void>.delayed(Duration.zero);
          await Future<void>.delayed(Duration.zero);
          await sub.cancel();

          final success = states
              .whereType<VolunteerDetailsActionSuccess>()
              .first;
          expect(success.details.level, 4);
          expect(success.details.levelTitle, 'متطوع نشيط');
          cubit.close();
        },
      );
    });

    group('editVolunteerData', () {
      test('success → emits actionSuccess with updated fields', () async {
        final details = fakeVolunteerDetails(name: 'قديم');
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockEditData(
            volunteerId: any(named: 'volunteerId'),
            fields: any(named: 'fields'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.editVolunteerData({'name': 'جديد', 'phone': '0100'});
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        final success = states.whereType<VolunteerDetailsActionSuccess>().first;
        expect(success.details.name, 'جديد');
        expect(success.details.phone, '0100');
        cubit.close();
      });
    });

    group('assignTask', () {
      test('success → emits actionSuccess', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockAssignTask(
            volunteerId: any(named: 'volunteerId'),
            taskId: any(named: 'taskId'),
            adminId: any(named: 'adminId'),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.assignTask(taskId: 'task-1', adminId: 'admin-1');
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionSuccess), isTrue);
        cubit.close();
      });

      test('failure → emits actionError', () async {
        final details = fakeVolunteerDetails();
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(
          () => mockAssignTask(
            volunteerId: any(named: 'volunteerId'),
            taskId: any(named: 'taskId'),
            adminId: any(named: 'adminId'),
          ),
        ).thenAnswer((_) async => Left(Failture(0, 'فشل التعيين')));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.assignTask(taskId: 'task-1', adminId: 'admin-1');
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsActionError), isTrue);
        cubit.close();
      });
    });

    group('loadAvailableTasks', () {
      test('success → emits availableTasks state', () async {
        final details = fakeVolunteerDetails();
        final tasks = [
          {'id': 'task-1', 'title': 'مهمة 1'},
        ];
        when(
          () => mockGetDetails(any()),
        ).thenAnswer((_) async => Right(details));
        when(() => mockGetTasks(any())).thenAnswer((_) async => Right(tasks));

        final cubit = buildCubit();
        await cubit.load('vol-1');

        final states = <VolunteerDetailsState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.loadAvailableTasks();
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(states.any((s) => s is VolunteerDetailsAvailableTasks), isTrue);
        final avail = states.whereType<VolunteerDetailsAvailableTasks>().first;
        expect(avail.tasks.length, 1);
        cubit.close();
      });
    });

    group('no-op when state has no details', () {
      test('suspendAccount does nothing when state is initial', () async {
        final cubit = buildCubit();
        // Don't call load() — state is initial, _currentDetails is null
        await cubit.suspendAccount();
        expect(cubit.state, isA<VolunteerDetailsInitial>());
        cubit.close();
      });
    });
  });
}
