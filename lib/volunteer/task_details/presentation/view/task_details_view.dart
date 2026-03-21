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
import 'widgets/task_error_body.dart';

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
              onRetry: () => context
                  .read<TaskDetailsCubit>()
                  .loadTaskDetails(widget.taskId),
            ),
            loaded: (task) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s18,
              ),
              child: Column(
                children: [
                  SizedBox(height: AppHeight.s10,),
                  TaskDetailsHeaderCard(task: task),
                  SizedBox(height: AppHeight.s16),
                  TaskDetailsTabSwitcher(
                    selectedIndex: _selectedTab,
                    onTabChanged: (i) => setState(() => _selectedTab = i),
                  ),
                  SizedBox(height: AppHeight.s24),
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
