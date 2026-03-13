import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/data/models/task_report_model.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_form_header.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_star_rating.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_submit_button.dart';

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
          color: Color(0xFF0C203B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReportFormHeader(
              title: 'رفع تقرير المهمة',
              onClose: () => Navigator.of(context).pop(),
            ),
            const Divider(color: Color(0xFF1E3A5F), height: 1),
            Flexible(
              child: _isLoading
                  ? const LoadingIndicator()
                  : _existingReport != null
                      ? _ExistingReportView(report: _existingReport!)
                      : BlocBuilder<ReportCubit, ReportState>(
                          builder: (context, state) {
                            final isSubmitting = state is ReportStateLoading;
                            return _ReportForm(
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

// ─── Existing report status view ───────────────────────────────────────────

class _ExistingReportView extends StatelessWidget {
  const _ExistingReportView({required this.report});

  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    final status = report['status'] as String? ?? 'pending';
    final (statusLabel, statusColor, statusIcon) = switch (status) {
      'approved' => (
          'تمت الموافقة',
          const Color(0xFF4CAF50),
          Icons.check_circle_rounded
        ),
      'rejected' => ('مرفوض', Colors.red, Icons.cancel_rounded),
      _ => (
          'قيد المراجعة',
          const Color(0xFFFBBF24),
          Icons.hourglass_top_rounded
        ),
    };

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSize.s20),
      child: Column(
        children: [
          SizedBox(height: AppHeight.s16),
          Icon(statusIcon, color: statusColor, size: 64.r),
          SizedBox(height: AppHeight.s16),
          Text(
            'لقد قمت برفع تقرير لهذه المهمة',
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s16,
              vertical: AppHeight.s8,
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.s20),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              statusLabel,
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: statusColor,
              ),
            ),
          ),
          if (report['admin_feedback'] != null) ...[
            SizedBox(height: AppHeight.s20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSize.s16),
              decoration: BoxDecoration(
                color: const Color(0xFF143764),
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ملاحظات المشرف',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: const Color(0xFF00ABD2),
                    ),
                  ),
                  SizedBox(height: AppHeight.s8),
                  Text(
                    report['admin_feedback'] as String,
                    textAlign: TextAlign.right,
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: AppHeight.s32),
        ],
      ),
    );
  }
}

// ─── Report form ───────────────────────────────────────────────────────────

class _ReportForm extends StatelessWidget {
  const _ReportForm({
    required this.formKey,
    required this.summaryCtrl,
    required this.challengesCtrl,
    required this.attendeesCtrl,
    required this.materialsCtrl,
    required this.notesCtrl,
    required this.objectivesMet,
    required this.rating,
    required this.isSubmitting,
    required this.onObjectivesChanged,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController summaryCtrl;
  final TextEditingController challengesCtrl;
  final TextEditingController attendeesCtrl;
  final TextEditingController materialsCtrl;
  final TextEditingController notesCtrl;
  final bool objectivesMet;
  final int rating;
  final bool isSubmitting;
  final ValueChanged<bool> onObjectivesChanged;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s20,
        vertical: AppHeight.s16,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormField(
              label: 'ملخص المهمة *',
              controller: summaryCtrl,
              maxLines: 4,
              hint: 'اكتب ملخصاً عما تم إنجازه...',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
            ),
            SizedBox(height: AppHeight.s16),
            _FormField(
              label: 'التحديات التي واجهتها',
              controller: challengesCtrl,
              maxLines: 3,
              hint: 'اذكر أي تحديات أو عقبات (اختياري)',
            ),
            SizedBox(height: AppHeight.s16),
            _FormField(
              label: 'عدد الحضور',
              controller: attendeesCtrl,
              hint: 'عدد المستفيدين أو الحضور',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: AppHeight.s16),
            _FormField(
              label: 'المواد الموزعة',
              controller: materialsCtrl,
              hint: 'المستلزمات التي تم توزيعها (اختياري)',
            ),
            SizedBox(height: AppHeight.s16),
            // Objectives met toggle
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s16,
                vertical: AppHeight.s12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF143764),
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Row(
                children: [
                  Switch(
                    value: objectivesMet,
                    onChanged: onObjectivesChanged,
                    activeThumbColor: const Color(0xFF00ABD2),
                  ),
                  SizedBox(width: AppWidth.s8),
                  Expanded(
                    child: Text(
                      'تم تحقيق الأهداف المطلوبة',
                      textAlign: TextAlign.right,
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppHeight.s16),
            ReportStarRating(
              rating: rating,
              onRatingChanged: onRatingChanged,
            ),
            SizedBox(height: AppHeight.s16),
            _FormField(
              label: 'ملاحظات إضافية',
              controller: notesCtrl,
              maxLines: 3,
              hint: 'أي ملاحظات أخرى (اختياري)',
            ),
            SizedBox(height: AppHeight.s24),
            ReportSubmitButton(
              isSubmitting: isSubmitting,
              onPressed: onSubmit,
            ),
            SizedBox(height: AppHeight.s24),
          ],
        ),
      ),
    );
  }
}

// ─── Text field helper ─────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: AppHeight.s6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textAlign: TextAlign.right,
          validator: validator,
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: const Color(0xFF143764),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              borderSide: const BorderSide(color: Color(0xFF1E3A5F)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              borderSide: const BorderSide(color: Color(0xFF00ABD2)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.s12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppWidth.s16,
              vertical: AppHeight.s12,
            ),
          ),
        ),
      ],
    );
  }
}
