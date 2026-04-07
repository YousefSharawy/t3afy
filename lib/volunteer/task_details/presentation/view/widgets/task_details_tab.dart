import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_paper_entity.dart';
import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/task_details_entity.dart';
import 'description_section.dart';
import 'existing_report_view.dart';
import 'location_section.dart';
import 'notes_card.dart';
import 'objectives_section.dart';
import 'report_button.dart';
import 'section_header.dart';
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
          SizedBox(height: AppHeight.s8),
        ],
        if (task.papers.isNotEmpty) ...[
          _VolunteerPapersSection(papers: task.papers),
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

    // Checked out but not yet reported — show report button.
    if (status == 'in_progress' && task.checkedOutAt != null) {
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

class _VolunteerPapersSection extends StatelessWidget {
  const _VolunteerPapersSection({required this.papers});

  final List<CampaignPaperEntity> papers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'أوراق التصاريح'),
        SizedBox(height: AppHeight.s8),
        SizedBox(
          height: 110.w,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: papers.length,
            itemBuilder: (context, index) {
              final paper = papers[index];
              final isPdf = paper.fileName.toLowerCase().endsWith('.pdf');
              return Padding(
                padding: EdgeInsetsDirectional.only(end: AppWidth.s8),
                child: GestureDetector(
                  onTap: () => isPdf
                      ? _openPdf(paper.fileUrl)
                      : _openFullScreen(context, index),
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: ColorManager.natural100,
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      child: isPdf
                          ? Icon(
                              Icons.picture_as_pdf_outlined,
                              size: 40.r,
                              color: ColorManager.error,
                            )
                          : CachedNetworkImage(
                              imageUrl: paper.fileUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => CustomShimmerWrapW(
                                width: 100.w,
                                height: 100.w,
                                itemCount: 1,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.s12,
                                ),
                              ),
                              errorWidget: (_, __, ___) => Icon(
                                Icons.broken_image_outlined,
                                size: 32.r,
                                color: ColorManager.natural400,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openPdf(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openFullScreen(BuildContext context, int initialIndex) {
    final imagePapers = papers
        .where((p) => !p.fileName.toLowerCase().endsWith('.pdf'))
        .toList();
    final imageIndex = papers
        .where((p) => !p.fileName.toLowerCase().endsWith('.pdf'))
        .toList()
        .indexWhere((p) => p.id == papers[initialIndex].id);
    if (imageIndex == -1) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _PaperFullScreenViewer(
          papers: imagePapers,
          initialIndex: imageIndex,
        ),
      ),
    );
  }
}

class _PaperFullScreenViewer extends StatefulWidget {
  const _PaperFullScreenViewer({
    required this.papers,
    required this.initialIndex,
  });

  final List<CampaignPaperEntity> papers;
  final int initialIndex;

  @override
  State<_PaperFullScreenViewer> createState() => _PaperFullScreenViewerState();
}

class _PaperFullScreenViewerState extends State<_PaperFullScreenViewer> {
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        itemCount: widget.papers.length,
        itemBuilder: (context, index) {
          final paper = widget.papers[index];
          return PhotoView(
            imageProvider: CachedNetworkImageProvider(paper.fileUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 64,
                color: Colors.white38,
              ),
            ),
          );
        },
      ),
    );
  }
}
