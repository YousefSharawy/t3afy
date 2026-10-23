import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'description_section.dart';
import 'existing_report_view.dart';
import 'location_section.dart';
import 'notes_card.dart';
import 'objectives_section.dart';
import 'permit_papers_section.dart';
import 'report_button.dart';
import 'supervisor_section.dart';

class TaskDetailsTab extends StatelessWidget {
  const TaskDetailsTab({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Space.vl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasLocation) ...[
          LocationSection(key: AppTutorialKeys.taskDetailsLocationKey, task: task),
          gap,
        ],
        if (task.description?.isNotEmpty == true) ...[
          DescriptionSection(description: task.description!),
          gap,
        ],
        if (task.objectives.isNotEmpty) ...[
          ObjectivesSection(objectives: task.objectives),
          gap,
        ],
        if (task.supervisorName != null && task.supervisorName!.isNotEmpty) ...[
          SupervisorSection(
            name: task.supervisorName!,
            phone: task.supervisorPhone,
          ),
          gap,
        ],
        if (task.notes?.isNotEmpty == true) ...[
          NotesCard(notes: task.notes!),
          gap,
        ],
        if (task.papers.isNotEmpty) ...[
          PermitPapersSection(papers: task.papers),
          gap,
        ],
        SizedBox(height: Space.vs),
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildBottomSection() {
    final status = task.assignmentStatus;

    // Pre-completed by admin or organically completed — check for a report.
    if (status == 'completed') {
      return _ExistingReportSection(
        taskId: task.id,
        fallback: const _StatusBanner(
          icon: AppIcons.done,
          tone: ColorManager.sproutText,
          fill: ColorManager.sproutSoft,
          text: 'تم احتساب المهمة مكتملة من قبل المسؤول',
        ),
      );
    }

    // Report submitted, awaiting admin review.
    if (status == 'pending_review') {
      return _ExistingReportSection(
        taskId: task.id,
        fallback: const _StatusBanner(
          icon: Icons.hourglass_top_rounded,
          tone: ColorManager.warning,
          fill: ColorManager.warningLight,
          text: 'تم رفع التقرير وهو قيد المراجعة',
        ),
      );
    }

    // Deadline passed without completion, or checked out but not yet
    // reported — show the report button.
    if (status == 'missed' ||
        (status == 'in_progress' && task.checkedOutAt != null)) {
      return ReportButton(
        key: AppTutorialKeys.taskDetailsReportKey,
        taskId: task.id,
        taskTitle: task.title,
      );
    }

    // Task not yet ended — show nothing actionable.
    return const _StatusBanner(
      icon: AppIcons.alarm,
      tone: ColorManager.inkMuted,
      fill: ColorManager.surfaceSunken,
      text: 'المهمة لم تنتهِ بعد',
    );
  }

  bool get _hasLocation =>
      task.locationName != null ||
      (task.locationLat != null && task.locationLng != null);
}

/// Reads the screen-level [ReportCubit] (created once above the tab switcher),
/// so switching tabs doesn't refetch the report or open a new channel.
class _ExistingReportSection extends StatefulWidget {
  const _ExistingReportSection({required this.taskId, required this.fallback});

  final String taskId;
  final Widget fallback;

  @override
  State<_ExistingReportSection> createState() => _ExistingReportSectionState();
}

class _ExistingReportSectionState extends State<_ExistingReportSection> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ReportCubit>();
    if (cubit.state is ReportStateInitial) {
      cubit.loadExistingReport(widget.taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportStateInitial ||
            state is ReportStateCheckingExisting) {
          return Skeleton(
            child: SkeletonBox(height: 72, radius: Radii.card),
          );
        }
        if (state is ReportStateExistingFound) {
          return ExistingReportView(report: state.report);
        }
        return widget.fallback;
      },
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.tone,
    required this.fill,
    required this.text,
  });

  final IconData icon;
  final Color tone;
  final Color fill;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: fill,
      padding: EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.vm),
      child: Row(
        children: [
          Icon(icon, color: tone, size: 20),
          SizedBox(width: Space.s),
          Expanded(child: Text(text, style: AppText.bodyStrong(color: tone))),
        ],
      ),
    );
  }
}
