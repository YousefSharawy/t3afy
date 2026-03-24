import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'review_info_row.dart';
import 'review_detail_card.dart';

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
              Toast.error.show(context, title: 'خطأ: $message');
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
              color: ColorManager.white,
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
                      color: ColorManager.natural200,
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
                          color: ColorManager.natural900,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close_rounded,
                          color: ColorManager.natural400,
                          size: 22.r,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: EdgeInsets.all(AppSize.s20),
                    children: [
                      ReviewInfoRow(label: 'المهمة', value: report.taskTitle),
                      SizedBox(height: AppHeight.s10),
                      ReviewInfoRow(label: 'المتطوع', value: report.volunteerName),
                      SizedBox(height: AppHeight.s10),
                      Row(
                        children: [
                          Text(
                            'التقييم',
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s12,
                              color: ColorManager.natural400,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Image.asset(
                                i < report.rating
                                    ? IconAssets.star
                                    : IconAssets.unstar,
                                width: 16.r,
                                height: 16.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppHeight.s16),
                      const Divider(color: ColorManager.navyLight),
                      SizedBox(height: AppHeight.s16),
                      ReviewDetailCard(title: 'ملخص المهمة', content: report.summary),
                      if (report.challenges != null) ...[
                        SizedBox(height: AppHeight.s12),
                        ReviewDetailCard(
                            title: 'التحديات', content: report.challenges!),
                      ],
                      if (report.attendeesCount != null) ...[
                        SizedBox(height: AppHeight.s12),
                        ReviewInfoRow(
                          label: 'عدد الحضور',
                          value: '${report.attendeesCount}',
                        ),
                      ],
                      SizedBox(height: AppHeight.s12),
                      ReviewInfoRow(
                        label: 'توزيع المواد',
                        value: report.materialsDistributed ? 'نعم' : 'لا',
                      ),
                      if (report.additionalNotes != null) ...[
                        SizedBox(height: AppHeight.s12),
                        ReviewDetailCard(
                          title: 'ملاحظات إضافية',
                          content: report.additionalNotes!,
                        ),
                      ],
                      if (report.adminFeedback != null) ...[
                        SizedBox(height: AppHeight.s12),
                        ReviewDetailCard(
                          title: 'ملاحظات المشرف',
                          content: report.adminFeedback!,
                          titleColor: ColorManager.cyanPrimary,
                        ),
                      ],
                      if (isPending) ...[
                        SizedBox(height: AppHeight.s24),
                        const Divider(color: ColorManager.navyLight),
                        SizedBox(height: AppHeight.s16),
                        Text(
                          'ملاحظات المراجعة (اختياري)',
                          textAlign: TextAlign.right,
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s13,
                            color: ColorManager.natural500,
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
                            color: ColorManager.natural900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'اكتب ملاحظاتك للمتطوع...',
                            hintStyle: getRegularStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s13,
                              color: ColorManager.natural400,
                            ),
                            filled: true,
                            fillColor: ColorManager.natural50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.s12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.s12),
                              borderSide: const BorderSide(
                                color: ColorManager.natural200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.s12),
                              borderSide: const BorderSide(
                                color: ColorManager.cyanPrimary,
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
                            final isProcessing = state.maybeWhen(
                                reviewing: () => true, orElse: () => false);
                            return Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: AppHeight.s48,
                                    child: ElevatedButton(
                                      onPressed: isProcessing
                                          ? null
                                          : () {
                                              HapticFeedback.mediumImpact();
                                              context
                                                  .read<AdminReportsCubit>()
                                                  .reviewReport(
                                                    reportId: report.id,
                                                    status: 'rejected',
                                                    feedback: _feedbackCtrl.text
                                                            .trim()
                                                            .isEmpty
                                                        ? null
                                                        : _feedbackCtrl.text.trim(),
                                                  );
                                            },
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
                                          : () {
                                              HapticFeedback.mediumImpact();
                                              context
                                                  .read<AdminReportsCubit>()
                                                  .reviewReport(
                                                    reportId: report.id,
                                                    status: 'approved',
                                                    feedback: _feedbackCtrl.text
                                                            .trim()
                                                            .isEmpty
                                                        ? null
                                                        : _feedbackCtrl.text.trim(),
                                                  );
                                            },
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
