import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'submit_report_sheet.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({super.key, required this.taskId, required this.taskTitle});

  final String taskId;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppHeight.s50,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => BlocProvider(
              create: (_) => getIt<ReportCubit>(),
              child: SubmitReportSheet(taskId: taskId, taskTitle: taskTitle),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.cyanPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s12),
          ),
          elevation: 0,
        ),
        child: Text(
          'رفع تقرير',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
