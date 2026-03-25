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
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/app_form_field.dart';
import 'package:t3afy/base/widgets/section_label.dart';

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
            decoration: BoxDecoration(
              color: ColorManager.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // ── Drag handle ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsetsDirectional.only(top: AppHeight.s12),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: ColorManager.natural200,
                      borderRadius: BorderRadius.circular(AppRadius.s2),
                    ),
                  ),
                ),
                // ── Title row ───────────────────────────────────────────────
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppWidth.s20,
                    vertical: AppHeight.s14,
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        'مراجعة التقرير',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s18,
                          color: ColorManager.natural900,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            color: ColorManager.natural100,
                            borderRadius:
                                BorderRadius.circular(AppRadius.s8),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: ColorManager.natural500,
                            size: 18.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Divider ─────────────────────────────────────────────────
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: ColorManager.natural200,
                ),
                // ── Scrollable content ──────────────────────────────────────
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: EdgeInsetsDirectional.all(AppSize.s20),
                    children: [
                      // ── Meta info card ───────────────────────────────────
                      _InfoCard(
                        children: [
                          _MetaRow(
                            icon: IconAssets.camp,
                            label: 'المهمة',
                            value: report.taskTitle,
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: ColorManager.natural100,
                          ),
                          _MetaRow(
                            icon: IconAssets.vol,
                            label: 'المتطوع',
                            value: report.volunteerName,
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: ColorManager.natural100,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: AppWidth.s12,
                              vertical: AppHeight.s10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'التقييم',
                                  style: getMediumStyle(
                                    fontFamily: FontConstants.fontFamily,
                                    fontSize: FontSize.s12,
                                    color: ColorManager.natural400,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: List.generate(
                                    report.rating,
                                    (i) => Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: AppWidth.s2),
                                      child: Image.asset(
                                        IconAssets.star,
                                        width: 16.r,
                                        height: 16.r,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppHeight.s20),

                      // ── Report content ───────────────────────────────────
                      const SectionLabel(label: 'ملخص المهمة'),
                      SizedBox(height: AppHeight.s8),
                      _ContentCard(text: report.summary),

                      if (report.challenges != null) ...[
                        SizedBox(height: AppHeight.s16),
                        const SectionLabel(label: 'التحديات'),
                        SizedBox(height: AppHeight.s8),
                        _ContentCard(text: report.challenges!),
                      ],

                      SizedBox(height: AppHeight.s16),

                      // ── Stats row ────────────────────────────────────────
                      _InfoCard(
                        children: [
                          if (report.attendeesCount != null) ...[
                            _MetaRow(
                              icon: IconAssets.group,
                              label: 'عدد الحضور',
                              value: '${report.attendeesCount}',
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: ColorManager.natural100,
                            ),
                          ],
                          _MetaRow(
                            icon: IconAssets.done,
                            label: 'توزيع المواد',
                            value: report.materialsDistributed ? 'نعم' : 'لا',
                          ),
                        ],
                      ),

                      if (report.additionalNotes != null) ...[
                        SizedBox(height: AppHeight.s16),
                        const SectionLabel(label: 'ملاحظات إضافية'),
                        SizedBox(height: AppHeight.s8),
                        _ContentCard(text: report.additionalNotes!),
                      ],

                      if (report.adminFeedback != null) ...[
                        SizedBox(height: AppHeight.s16),
                        SectionLabel(
                          label: 'ملاحظات المشرف',
                        ),
                        SizedBox(height: AppHeight.s8),
                        _ContentCard(
                          text: report.adminFeedback!,
                          textColor: ColorManager.cyanPrimary,
                          borderColor: ColorManager.cyanPrimary
                              .withValues(alpha: 0.3),
                          backgroundColor: ColorManager.primary50,
                        ),
                      ],

                      // ── Review actions (pending only) ─────────────────────
                      if (isPending) ...[
                        SizedBox(height: AppHeight.s24),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: ColorManager.natural200,
                        ),
                        SizedBox(height: AppHeight.s16),
                        const SectionLabel(label: 'ملاحظات المراجعة'),
                        SizedBox(height: AppHeight.s4),
                        Text(
                          'اختياري',
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s12,
                            color: ColorManager.natural400,
                          ),
                        ),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _feedbackCtrl,
                          hint: 'اكتب ملاحظاتك للمتطوع...',
                          maxLines: 3,
                          fillColor: ColorManager.white,
                          borderColor: ColorManager.natural200,
                          focusedBorderColor: ColorManager.cyanPrimary,
                          textColor: ColorManager.natural900,
                          hintColor: ColorManager.natural400,
                        ),
                        SizedBox(height: AppHeight.s20),
                        BlocBuilder<AdminReportsCubit, AdminReportsState>(
                          buildWhen: (prev, curr) =>
                              curr.maybeWhen(
                                  reviewing: () => true,
                                  orElse: () => false) ||
                              curr.maybeWhen(
                                  reviewed: () => true, orElse: () => false),
                          builder: (context, state) {
                            final isProcessing = state.maybeWhen(
                                reviewing: () => true, orElse: () => false);
                            return Row(
                              children: [
                                Expanded(
                                  child: PrimaryElevatedButton(
                                    title: 'رفض',
                                    height: AppHeight.s48,
                                    buttonRadius: AppRadius.s12,
                                    backGroundColor: ColorManager.error,
                                    onPress: isProcessing
                                        ? () {}
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
                                                      : _feedbackCtrl.text
                                                          .trim(),
                                                );
                                          },
                                  ),
                                ),
                                SizedBox(width: AppWidth.s12),
                                Expanded(
                                  child: PrimaryElevatedButton(
                                    title: isProcessing ? '' : 'موافقة',
                                    height: AppHeight.s48,
                                    buttonRadius: AppRadius.s12,
                                    backGroundColor: ColorManager.success,
                                    isLoading: isProcessing,
                                    onPress: isProcessing
                                        ? () {}
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
                                                      : _feedbackCtrl.text
                                                          .trim(),
                                                );
                                          },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],

                      SizedBox(height: AppHeight.s100),
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

// ── Private helper widgets ────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: ColorManager.natural100, width: 0.5),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s10,
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 20.r, height: 20.r),
          SizedBox(width: AppWidth.s10),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural400,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: ColorManager.natural800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(AppSize.s14),
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: borderColor ?? ColorManager.natural100,
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: getRegularStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s13,
          color: textColor ?? ColorManager.natural700,
          height: 1.6,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
