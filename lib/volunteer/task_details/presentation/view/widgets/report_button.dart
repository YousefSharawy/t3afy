import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';

import 'submit_report_sheet.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  final String taskId;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return PrimaryElevatedButton(
      title: 'رفع تقرير',
      icon: AppIcons.reports,
      onPress: () async {
        final cubit = context.read<ReportCubit>();
        final submitted = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          // Drag-to-dismiss bypasses PopScope; the sheet confirms before
          // discarding a filled form, so dismissal goes through maybePop.
          enableDrag: false,
          backgroundColor: ColorManager.transparent,
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: SubmitReportSheet(taskId: taskId, taskTitle: taskTitle),
          ),
        );
        if (submitted == true && context.mounted) {
          context.pop(true);
        }
      },
    );
  }
}
