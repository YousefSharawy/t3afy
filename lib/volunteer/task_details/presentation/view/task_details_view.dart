import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/data/sources/check_in_impl_data_source.dart';
import 'package:t3afy/volunteer/task_details/domain/entities/task_details_entity.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../cubit/task_details_cubit.dart';
import 'widgets/check_in_out_card.dart';
import 'widgets/task_details_header_card.dart';
import 'widgets/task_details_tab.dart';
import 'widgets/task_details_tab_switcher.dart';
import 'widgets/task_supplies_tab.dart';
import 'widgets/task_error_body.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'تفاصيل المهمة',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: ColorManager.blueOne900,
          ),
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorManager.blueOne900,
            size: 20.sp,
          ),
        ),
      ),
      body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF00ABD2)),
            ),
            error: (message) => TaskErrorBody(
              message: message,
              onRetry: () => context.read<TaskDetailsCubit>().loadTaskDetails(
                widget.taskId,
              ),
            ),
            loaded: (task) {
              final showCheckIn = _shouldShowCheckIn(task);
              if (!_tutorialShown &&
                  !LocalAppStorage.isTaskDetailsTutorialCompleted()) {
                _tutorialShown = true;
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    _showTutorial(context);
                  }
                });
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
                child: Column(
                  children: [
                    SizedBox(height: AppHeight.s10),
                    TaskDetailsHeaderCard(
                      key: AppTutorialKeys.taskDetailsHeaderKey,
                      task: task,
                    ),
                    if (showCheckIn) ...[
                      SizedBox(height: AppHeight.s16),
                      BlocProvider<LocationCubit>(
                        create: (_) => LocationCubit(
                          taskId: task.id,
                          taskLat: task.locationLat!,
                          taskLng: task.locationLng!,
                          dataSource: CheckInImplDataSource(),
                        )..init(),
                        child: CheckInOutCard(
                          timeEnd: task.timeEnd,
                          date: task.date,
                        ),
                      ),
                    ],
                    SizedBox(height: AppHeight.s16),
                    TaskDetailsTabSwitcher(
                      key: AppTutorialKeys.taskDetailsTabSwitcherKey,
                      selectedIndex: _selectedTab,
                      onTabChanged: (i) => setState(() => _selectedTab = i),
                    ),
                    SizedBox(height: AppHeight.s24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: _selectedTab == 0
                          ? TaskDetailsTab(key: const ValueKey(0), task: task)
                          : TaskSuppliesTab(key: const ValueKey(1), task: task),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    TutorialService.createTutorial(
      targets: _createTargets(),
      onFinish: () {
        LocalAppStorage.setTaskDetailsTutorialCompleted(true);
      },
      onSkip: () {
        LocalAppStorage.setTaskDetailsTutorialCompleted(true);
      },
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TutorialService.createTarget(
        identify: "task_header",
        keyTarget: AppTutorialKeys.taskDetailsHeaderKey,
        title: "تفاصيل المهمة الأساسية",
        description: "استعرض مكان المهمة ومعلومات المستفيد والوقت المتوقع",
        contentPosition: 1,
        stepIndex: 1,
        totalSteps: 2,
      ),
      TutorialService.createTarget(
        identify: "tab_switcher",
        keyTarget: AppTutorialKeys.taskDetailsTabSwitcherKey,
        title: "التنقل السريع",
        description:
            "انتقل هنا بين تفاصيل الغرفة وقائمة المستلزمات الطبية المطلوبة (إن وجدت)",
        contentPosition: 1,
        stepIndex: 2,
        totalSteps: 2,
      ),
    ];
  }
}
