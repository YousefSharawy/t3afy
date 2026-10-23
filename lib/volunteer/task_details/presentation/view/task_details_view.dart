import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/app_segmented_tabs.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/volunteer/task_details/data/sources/check_in_impl_data_source.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_details_entity.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../cubit/task_details_cubit.dart';
import 'widgets/check_in_out_card.dart';
import 'widgets/task_details_header_card.dart';
import 'widgets/task_details_skeleton.dart';
import 'widgets/task_details_tab.dart';
import 'widgets/task_supplies_tab.dart';

class TaskDetailsView extends StatefulWidget {
  const TaskDetailsView({super.key, required this.taskId});

  final String taskId;

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  int _selectedTab = 0;
  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    context.read<TaskDetailsCubit>().loadTaskDetails(widget.taskId);
  }

  /// Returns true when:
  /// - task has GPS coordinates
  /// - current time is within 30 min before time_start until time_end
  bool _shouldShowCheckIn(TaskDetailsEntity task) {
    if (task.locationLat == null || task.locationLng == null) return false;
    if (task.locationLat == 0 && task.locationLng == 0) return false;
    try {
      final d = DateTime.parse(task.date);
      final startParts = task.timeStart.split(':');
      final endParts = task.timeEnd.split(':');
      final startHour = int.tryParse(startParts[0]) ?? 0;
      final startMin = int.tryParse(startParts[1]) ?? 0;
      final endHour = int.tryParse(endParts[0]) ?? 23;
      final endMin = int.tryParse(endParts[1]) ?? 59;
      final windowStart = DateTime(
        d.year,
        d.month,
        d.day,
        startHour,
        startMin,
      ).subtract(const Duration(minutes: 30));
      final windowEnd = DateTime(d.year, d.month, d.day, endHour, endMin);
      final now = DateTime.now();
      return now.isAfter(windowStart) && now.isBefore(windowEnd);
    } catch (_) {
      return false;
    }
  }

  Future<void> _refresh() async {
    final error = await context.read<TaskDetailsCubit>().refresh();
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  @override
  Widget build(BuildContext context) {
    // Created once for the screen (not inside the tab switcher) so switching
    // tabs doesn't refetch the report or open a new realtime channel.
    return BlocProvider<ReportCubit>(
      create: (_) => getIt<ReportCubit>(),
      child: Scaffold(
        backgroundColor: ColorManager.canvas,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppPageHeader(title: 'تفاصيل المهمة', showBack: true),
              Expanded(
                child: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: AppMotion.of(context),
                      child: state.when(
                        initial: () => const TaskDetailsSkeleton(),
                        loading: () => const TaskDetailsSkeleton(),
                        error: (message) => ErrorState(
                          message: message,
                          onRetry: () => context
                              .read<TaskDetailsCubit>()
                              .loadTaskDetails(widget.taskId),
                        ),
                        loaded: (task) => _buildLoaded(context, task),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, TaskDetailsEntity task) {
    if (!_tutorialShown && !LocalAppStorage.isTaskDetailsTutorialCompleted()) {
      _tutorialShown = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showTutorial();
      });
    }

    return RefreshIndicator(
      key: const ValueKey('task-details-loaded'),
      color: ColorManager.brand,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(
          Space.gutter,
          Space.vs,
          Space.gutter,
          Space.vxl + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskDetailsHeaderCard(
              key: AppTutorialKeys.taskDetailsHeaderKey,
              task: task,
            ),
            if (_shouldShowCheckIn(task)) ...[
              SizedBox(height: Space.vl),
              BlocProvider<LocationCubit>(
                create: (_) => LocationCubit(
                  taskId: task.id,
                  taskLat: task.locationLat!,
                  taskLng: task.locationLng!,
                  dataSource: CheckInImplDataSource(),
                  checkedInAt: task.checkedInAt,
                  checkedOutAt: task.checkedOutAt,
                  verifiedHours: task.verifiedHours,
                )..init(),
                child: BlocListener<LocationCubit, LocationState>(
                  listener: (context, s) {
                    final cubit = context.read<TaskDetailsCubit>();
                    if (s is LocationCheckedIn) cubit.applyCheckIn(s.checkedInAt);
                    if (s is LocationCheckedOut) {
                      cubit.applyCheckOut(
                        s.checkedInAt,
                        s.checkedOutAt,
                        s.verifiedHours,
                      );
                    }
                  },
                  child: CheckInOutCard(timeEnd: task.timeEnd, date: task.date),
                ),
              ),
            ],
            SizedBox(height: Space.vl),
            AppSegmentedTabs(
              key: AppTutorialKeys.taskDetailsTabSwitcherKey,
              labels: const ['التفاصيل', 'المستلزمات'],
              counts: [null, task.supplies.length],
              selectedIndex: _selectedTab,
              onChanged: (i) => setState(() => _selectedTab = i),
            ),
            SizedBox(height: Space.vl),
            AnimatedSwitcher(
              duration: AppMotion.of(context),
              child: _selectedTab == 0
                  ? TaskDetailsTab(key: const ValueKey(0), task: task)
                  : TaskSuppliesTab(key: const ValueKey(1), task: task),
            ),
          ],
        ),
      ),
    );
  }

  void _showTutorial() {
    TutorialService.createTutorial(
      targets: _createTargets(),
      onFinish: () => LocalAppStorage.setTaskDetailsTutorialCompleted(true),
      onSkip: () => LocalAppStorage.setTaskDetailsTutorialCompleted(true),
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    // Location / report steps only when those widgets are on screen.
    final steps =
        <({GlobalKey key, String id, String title, String body, ContentAlign align})>[
          (
            key: AppTutorialKeys.taskDetailsHeaderKey,
            id: 'task_header',
            title: 'تفاصيل المهمة الأساسية',
            body: 'استعرض نوع المهمة وحالتها وموعدها والنقاط التي تحصل عليها',
            align: ContentAlign.bottom,
          ),
          (
            key: AppTutorialKeys.taskDetailsTabSwitcherKey,
            id: 'tab_switcher',
            title: 'التنقل السريع',
            body: 'انتقل بين تفاصيل المهمة وقائمة المستلزمات المطلوبة',
            align: ContentAlign.bottom,
          ),
          (
            key: AppTutorialKeys.taskDetailsLocationKey,
            id: 'task_location',
            title: 'موقع المهمة',
            body: 'اضغط على الخريطة أو زر الاتجاهات للوصول إلى موقع المهمة',
            align: ContentAlign.top,
          ),
          (
            key: AppTutorialKeys.taskDetailsReportKey,
            id: 'task_report',
            title: 'رفع التقرير',
            body: 'بعد انتهاء المهمة ارفع تقريرك لاحتساب ساعاتك ونقاطك',
            align: ContentAlign.top,
          ),
        ].where((s) => s.key.currentContext != null).toList();

    return [
      for (var i = 0; i < steps.length; i++)
        TutorialService.buildTarget(
          identify: steps[i].id,
          keyTarget: steps[i].key,
          title: steps[i].title,
          description: steps[i].body,
          contentAlign: steps[i].align,
          stepIndex: i + 1,
          totalSteps: steps.length,
        ),
    ];
  }
}
