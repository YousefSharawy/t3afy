import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';

import 'existing_report_view.dart';
import 'report_form.dart';
import 'report_form_header.dart';

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
  static const _defaultRating = 5;

  final _formKey = GlobalKey<FormState>();

  final _summaryCtrl = TextEditingController();
  final _challengesCtrl = TextEditingController();
  final _attendeesCtrl = TextEditingController();
  final _materialsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  int _rating = _defaultRating;

  bool get _isDirty =>
      _rating != _defaultRating ||
      [
        _summaryCtrl,
        _challengesCtrl,
        _attendeesCtrl,
        _materialsCtrl,
        _notesCtrl,
      ].any((c) => c.text.trim().isNotEmpty);

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

  Future<void> _onPopInvoked(bool didPop, Object? _) async {
    if (didPop) return;
    if (context.read<ReportCubit>().state is ReportStateLoading) return;
    final discard =
        !_isDirty ||
        await showConfirmDialog(
          context,
          title: 'تجاهل التقرير؟',
          body: 'لم يتم إرسال التقرير بعد، وستفقد ما كتبته.',
          confirmLabel: 'تجاهل',
          isDestructive: true,
        );
    if (discard && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
      child: BlocListener<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state is ReportStateSuccess) {
            Toast.success.show(context, title: 'تم إرسال التقرير بنجاح');
            Navigator.of(context).pop(true);
          } else if (state is ReportStateError) {
            Toast.error.show(context, title: state.message);
          }
        },
        // Lift the sheet above the keyboard so the scroll viewport ends at
        // the keyboard and the focused field is scrolled into view.
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.92,
            ),
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Radii.sheet),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReportFormHeader(
                  title: 'رفع تقرير',
                  subtitle: widget.taskTitle,
                  onClose: () => Navigator.of(context).maybePop(),
                ),
                Flexible(
                  child: BlocBuilder<ReportCubit, ReportState>(
                    builder: (context, state) {
                      if (state is ReportStateCheckingExisting ||
                          state is ReportStateInitial) {
                        return Padding(
                          padding: EdgeInsets.all(Space.gutter),
                          child: Skeleton(
                            child: Column(
                              children: [
                                SkeletonBox(height: 110, radius: Radii.input),
                                SizedBox(height: Space.vl),
                                SkeletonBox(height: 72, radius: Radii.input),
                              ],
                            ),
                          ),
                        );
                      }
                      if (state is ReportStateExistingFound) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            Space.gutter,
                            Space.vs,
                            Space.gutter,
                            Space.vxl,
                          ),
                          child: ExistingReportView(report: state.report),
                        );
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
                        onCancel: () => Navigator.of(context).maybePop(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
