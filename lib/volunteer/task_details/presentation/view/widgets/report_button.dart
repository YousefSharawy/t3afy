import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'submit_report_sheet.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({super.key, required this.taskId, required this.taskTitle});

  final String taskId;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return PrimaryElevatedButton(
      title: 'رفع تقرير',
      width: double.infinity,
      height: AppHeight.s46,
      backGroundColor: ColorManager.primary500,
      buttonRadius: AppRadius.s24,
      textStyle: getBoldStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s16,
        color: ColorManager.white,
      ),
      onPress: () {
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
    );
  }
}
