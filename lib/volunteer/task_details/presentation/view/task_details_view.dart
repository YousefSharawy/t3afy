import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import '../cubit/task_details_cubit.dart';
import 'widgets/task_details_header_card.dart';
import 'widgets/task_details_tab.dart';
import 'widgets/task_details_tab_switcher.dart';
import 'widgets/task_supplies_tab.dart';

class TaskDetailsView extends StatefulWidget {
  const TaskDetailsView({super.key, required this.taskId});

  final String taskId;

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskDetailsCubit>().loadTaskDetails(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
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
            size: 20.r,
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
            error: (message) => _ErrorBody(
              message: message,
              onRetry: () => context
                  .read<TaskDetailsCubit>()
                  .loadTaskDetails(widget.taskId),
            ),
            loaded: (task) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s16,
                vertical: AppHeight.s16,
              ),
              child: Column(
                children: [
                  TaskDetailsHeaderCard(task: task),
                  SizedBox(height: AppHeight.s16),
                  TaskDetailsTabSwitcher(
                    selectedIndex: _selectedTab,
                    onTabChanged: (i) => setState(() => _selectedTab = i),
                  ),
                  SizedBox(height: AppHeight.s16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: _selectedTab == 0
                        ? TaskDetailsTab(
                            key: const ValueKey(0),
                            task: task,
                          )
                        : TaskSuppliesTab(
                            key: const ValueKey(1),
                            task: task,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.r,
              color: ColorManager.error,
            ),
            SizedBox(height: AppHeight.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.error,
              ),
            ),
            SizedBox(height: AppHeight.s20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ABD2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
              ),
              child: Text(
                'إعادة المحاولة',
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
