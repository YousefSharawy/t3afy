import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_form_header.dart';
import '../../../../../app/resources/values_manager.dart';
import 'existing_report_view.dart';
import 'report_form.dart';

class SubmitReportSheet extends StatefulWidget {
  const SubmitReportSheet({
    super.key,
    required this.taskId,
    required this.taskTitle,
  });

  final String taskId;
  final String taskTitle;

  @override
  State<SubmitReportSheet> createState() => _SubmitReportSheetState();
}

class _SubmitReportSheetState extends State<SubmitReportSheet> {
  final _formKey = GlobalKey<FormState>();

  final _summaryCtrl = TextEditingController();
  final _challengesCtrl = TextEditingController();
  final _attendeesCtrl = TextEditingController();
  final _materialsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  int _rating = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReportCubit>().loadExistingReport(widget.taskId);
      }
    });
  }

  @override
  void dispose() {
    _summaryCtrl.dispose();
    _challengesCtrl.dispose();
    _attendeesCtrl.dispose();
    _materialsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ReportCubit>().submitReport(
      taskId: widget.taskId,
      summary: _summaryCtrl.text.trim(),
      challenges: _challengesCtrl.text.trim(),
      attendeesCountStr: _attendeesCtrl.text,
      materials: _materialsCtrl.text.trim(),
      additionalNotes: _notesCtrl.text.trim(),
      rating: _rating,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportStateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال التقرير بنجاح ✓'),
              backgroundColor: ColorManager.success,
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state is ReportStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.error,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.s24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppHeight.s18),
            Container(
              width: AppWidth.s39,
              height: AppHeight.s4,
              decoration: BoxDecoration(
                color: ColorManager.natural500,
                borderRadius: BorderRadius.circular(AppRadius.s45),
              ),
            ),
            SizedBox(height: AppHeight.s16),
            ReportFormHeader(
              title: 'رفع تقرير',
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(
              child: BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  if (state is ReportStateCheckingExisting) {
                    return const LoadingIndicator();
                  }
                  if (state is ReportStateExistingFound) {
                    return ExistingReportView(report: state.report);
                  }
                  return ReportForm(
                    formKey: _formKey,
                    summaryCtrl: _summaryCtrl,
                    challengesCtrl: _challengesCtrl,
                    attendeesCtrl: _attendeesCtrl,
                    materialsCtrl: _materialsCtrl,
                    notesCtrl: _notesCtrl,
                    rating: _rating,
                    isSubmitting: state is ReportStateLoading,
                    onRatingChanged: (v) => setState(() => _rating = v),
                    onSubmit: _submit,
                    onCancel: () => Navigator.of(context).pop(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
