import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_form_header.dart';
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
  final _client = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _summaryCtrl = TextEditingController();
  final _challengesCtrl = TextEditingController();
  final _attendeesCtrl = TextEditingController();
  final _materialsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _objectivesMet = true;
  int _rating = 5;
  bool _isLoading = true;
  Map<String, dynamic>? _existingReport;

  @override
  void initState() {
    super.initState();
    _checkExistingReport();
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

  Future<void> _checkExistingReport() async {
    final userId = LocalAppStorage.getUserId();
    if (userId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final result = await _client
          .from('task_reports')
          .select()
          .eq('task_id', widget.taskId)
          .eq('user_id', userId)
          .maybeSingle();
      if (mounted) {
        setState(() {
          _existingReport = result;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = LocalAppStorage.getUserId();
    if (userId == null) return;

    final model = TaskReportModel(
      taskId: widget.taskId,
      userId: userId,
      summary: _summaryCtrl.text.trim(),
      challenges: _challengesCtrl.text.trim(),
      attendeesCount: int.tryParse(_attendeesCtrl.text),
      materialsDistributed: _materialsCtrl.text.trim().isNotEmpty,
      objectivesMet: _objectivesMet,
      additionalNotes: _notesCtrl.text.trim(),
      rating: _rating,
    );

    context.read<ReportCubit>().submitReport(model);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportStateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال التقرير بنجاح ✓'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state is ReportStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReportFormHeader(
              title: 'رفع تقرير المهمة',
              onClose: () => Navigator.of(context).pop(),
            ),
            Divider(color: ColorManager.navyLight, height: 1),
            Flexible(
              child: _isLoading
                  ? const LoadingIndicator()
                  : _existingReport != null
                      ? ExistingReportView(report: _existingReport!)
                      : BlocBuilder<ReportCubit, ReportState>(
                          builder: (context, state) {
                            final isSubmitting = state is ReportStateLoading;
                            return ReportForm(
                              formKey: _formKey,
                              summaryCtrl: _summaryCtrl,
                              challengesCtrl: _challengesCtrl,
                              attendeesCtrl: _attendeesCtrl,
                              materialsCtrl: _materialsCtrl,
                              notesCtrl: _notesCtrl,
                              objectivesMet: _objectivesMet,
                              rating: _rating,
                              isSubmitting: isSubmitting,
                              onObjectivesChanged: (v) =>
                                  setState(() => _objectivesMet = v),
                              onRatingChanged: (v) =>
                                  setState(() => _rating = v),
                              onSubmit: _submit,
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
