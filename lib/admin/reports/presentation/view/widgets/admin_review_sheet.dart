import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';

class AdminReviewSheet extends StatefulWidget {
  const AdminReviewSheet({super.key, required this.report});

  final AdminReportEntity report;

  @override
  State<AdminReviewSheet> createState() => _AdminReviewSheetState();
}

class _AdminReviewSheetState extends State<AdminReviewSheet> {
  final _feedbackCtrl = TextEditingController();

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final isPending = report.status == 'pending';

    return BlocListener<AdminReportsCubit, AdminReportsState>(
      listenWhen: (prev, curr) =>
          curr.maybeWhen(reviewed: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          reviewed: () => Navigator.of(context).pop(true),
          orElse: () {},
        );
      },
      child: BlocListener<AdminReportsCubit, AdminReportsState>(
        listenWhen: (prev, curr) =>
            curr.maybeWhen(error: (_) => true, orElse: () => false),
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ: $message'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            orElse: () {},
          );
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollCtrl) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0C203B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: AppHeight.s12),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.s2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s20,
                    vertical: AppHeight.s14,
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        'مراجعة التقرير',
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s16,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 22.r,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF1E3A5F), height: 1),
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: EdgeInsets.all(AppSize.s20),
                    children: [
                      _InfoRow(label: 'المهمة', value: report.taskTitle),
                      SizedBox(height: AppHeight.s10),
                      _InfoRow(label: 'المتطوع', value: report.volunteerName),
                      SizedBox(height: AppHeight.s10),
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            'التقييم',
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          SizedBox(width: AppWidth.s8),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < report.rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: i < report.rating
                                    ? const Color(0xFFFBBF24)
                                    : Colors.white.withValues(alpha: 0.2),
                                size: 16.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppHeight.s16),
                      const Divider(color: Color(0xFF1E3A5F)),
                      SizedBox(height: AppHeight.s16),
                      _DetailCard(title: 'ملخص المهمة', content: report.summary),
                      if (report.challenges != null) ...[
                        SizedBox(height: AppHeight.s12),
                        _DetailCard(
                            title: 'التحديات', content: report.challenges!),
                      ],
                      if (report.attendeesCount != null) ...[
                        SizedBox(height: AppHeight.s12),
                        _InfoRow(
                          label: 'عدد الحضور',
                          value: '${report.attendeesCount}',
                        ),
                      ],
                      SizedBox(height: AppHeight.s12),
                      _InfoRow(
                        label: 'توزيع المواد',
                        value: report.materialsDistributed ? 'نعم' : 'لا',
                      ),
                      SizedBox(height: AppHeight.s12),
                      _InfoRow(
                        label: 'تحقيق الأهداف',
                        value: report.objectivesMet ? 'نعم' : 'لا',
                        valueColor: report.objectivesMet
                            ? const Color(0xFF4CAF50)
                            : Colors.red,
                      ),
                      if (report.additionalNotes != null) ...[
                        SizedBox(height: AppHeight.s12),
                        _DetailCard(
                          title: 'ملاحظات إضافية',
                          content: report.additionalNotes!,
                        ),
                      ],
                      if (report.adminFeedback != null) ...[
                        SizedBox(height: AppHeight.s12),
                        _DetailCard(
                          title: 'ملاحظات المشرف',
                          content: report.adminFeedback!,
                          titleColor: const Color(0xFF00ABD2),
                        ),
                      ],
                      if (isPending) ...[
                        SizedBox(height: AppHeight.s24),
                        const Divider(color: Color(0xFF1E3A5F)),
                        SizedBox(height: AppHeight.s16),
                        Text(
                          'ملاحظات المراجعة (اختياري)',
                          textAlign: TextAlign.right,
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s13,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: AppHeight.s8),
                        TextFormField(
                          controller: _feedbackCtrl,
                          maxLines: 3,
                          textAlign: TextAlign.right,
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s13,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'اكتب ملاحظاتك للمتطوع...',
                            hintStyle: getRegularStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s13,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF143764),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s12),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s12),
                              borderSide: const BorderSide(
                                color: Color(0xFF00ABD2),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppWidth.s16,
                              vertical: AppHeight.s12,
                            ),
                          ),
                        ),
                        SizedBox(height: AppHeight.s20),
                        BlocBuilder<AdminReportsCubit, AdminReportsState>(
                          buildWhen: (prev, curr) =>
                              curr.maybeWhen(
                                  reviewing: () => true, orElse: () => false) ||
                              curr.maybeWhen(
                                  reviewed: () => true, orElse: () => false),
                          builder: (context, state) {
                            final isProcessing =
                                state.maybeWhen(reviewing: () => true, orElse: () => false);
                            return Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: AppHeight.s48,
                                    child: ElevatedButton(
                                      onPressed: isProcessing
                                          ? null
                                          : () => context
                                              .read<AdminReportsCubit>()
                                              .reviewReport(
                                                reportId: report.id,
                                                status: 'rejected',
                                                feedback: _feedbackCtrl.text
                                                    .trim()
                                                    .isEmpty
                                                    ? null
                                                    : _feedbackCtrl.text
                                                        .trim(),
                                              ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.s12,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'رفض',
                                        style: getBoldStyle(
                                          fontFamily: FontConstants.fontFamily,
                                          fontSize: FontSize.s14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppWidth.s12),
                                Expanded(
                                  child: SizedBox(
                                    height: AppHeight.s48,
                                    child: ElevatedButton(
                                      onPressed: isProcessing
                                          ? null
                                          : () => context
                                              .read<AdminReportsCubit>()
                                              .reviewReport(
                                                reportId: report.id,
                                                status: 'approved',
                                                feedback: _feedbackCtrl.text
                                                    .trim()
                                                    .isEmpty
                                                    ? null
                                                    : _feedbackCtrl.text
                                                        .trim(),
                                              ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4CAF50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.s12,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: isProcessing
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            )
                                          : Text(
                                              'موافقة',
                                              style: getBoldStyle(
                                                fontFamily:
                                                    FontConstants.fontFamily,
                                                fontSize: FontSize.s14,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                      SizedBox(height: AppHeight.s24),
                    ],
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

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: valueColor ?? Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.content,
    this.titleColor,
  });

  final String title;
  final String content;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s14),
      decoration: BoxDecoration(
        color: const Color(0xFF143764),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: titleColor ?? const Color(0xFF00ABD2),
            ),
          ),
          SizedBox(height: AppHeight.s6),
          Text(
            content,
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
