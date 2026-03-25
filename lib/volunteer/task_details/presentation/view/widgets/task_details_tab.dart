import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'description_section.dart';
import 'existing_report_view.dart';
import 'location_section.dart';
import 'notes_card.dart';
import 'objectives_section.dart';
import 'report_button.dart';
import 'supervisor_section.dart';

class TaskDetailsTab extends StatelessWidget {
  const TaskDetailsTab({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_hasLocation) ...[
          LocationSection(task: task),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.description?.isNotEmpty == true) ...[
          DescriptionSection(description: task.description!),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.objectives.isNotEmpty) ...[
          ObjectivesSection(objectives: task.objectives),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.supervisorName != null) ...[
          SupervisorSection(
            name: task.supervisorName!,
            phone: task.supervisorPhone,
          ),
          SizedBox(height: AppHeight.s8),
        ],
        if (task.notes?.isNotEmpty == true) ...[
          NotesCard(notes: task.notes!),
          SizedBox(height: AppHeight.s16),
        ],
        _buildBottomSection(context),
        SizedBox(height: AppHeight.s24),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    final status = task.assignmentStatus;

    // Pre-completed by admin or organically completed — check for a report.
    if (status == 'completed') {
      return BlocProvider<ReportCubit>(
        create: (_) => getIt<ReportCubit>()..loadExistingReport(task.id),
        child: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            if (state is ReportStateCheckingExisting) {
              return const LoadingIndicator();
            }
            if (state is ReportStateExistingFound) {
              return ExistingReportView(report: state.report);
            }
            // No report found — was pre-completed by admin.
            return _adminCompletedBanner();
          },
        ),
      );
    }

    // Report submitted, awaiting admin review.
    if (status == 'pending_review') {
      return BlocProvider<ReportCubit>(
        create: (_) => getIt<ReportCubit>()..loadExistingReport(task.id),
        child: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            if (state is ReportStateCheckingExisting) {
              return const LoadingIndicator();
            }
            if (state is ReportStateExistingFound) {
              return ExistingReportView(report: state.report);
            }
            return _pendingReviewBanner();
          },
        ),
      );
    }

    // Deadline has passed without completion — show report button.
    if (status == 'missed') {
      return ReportButton(taskId: task.id, taskTitle: task.title);
    }

    // Task not yet ended — show nothing actionable.
    return _notEndedBanner();
  }

  Widget _adminCompletedBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Text(
        'تم احتساب المهمة مكتملة من قبل المسؤول',
        textAlign: TextAlign.center,
        style: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s14,
          color: const Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _pendingReviewBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.warning, width: 0.5),
      ),
      child: Text(
        'تم رفع التقرير وهو قيد المراجعة',
        textAlign: TextAlign.center,
        style: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s14,
          color: ColorManager.warning,
        ),
      ),
    );
  }

  Widget _notEndedBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.natural50,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.natural200, width: 0.5),
      ),
      child: Text(
        'المهمة لم تنتهِ بعد',
        textAlign: TextAlign.center,
        style: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s14,
          color: ColorManager.natural500,
        ),
      ),
    );
  }

  bool get _hasLocation =>
      task.locationName != null ||
      (task.locationLat != null && task.locationLng != null);
}
