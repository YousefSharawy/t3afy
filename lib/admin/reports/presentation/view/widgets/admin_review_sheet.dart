import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_report_card.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/review_detail_card.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/review_info_row.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/core/utils/date_ar.dart';

class AdminReviewSheet extends StatefulWidget {
  const AdminReviewSheet({super.key, required this.report});

  final AdminReportEntity report;

  @override
  State<AdminReviewSheet> createState() => _AdminReviewSheetState();
}

class _AdminReviewSheetState extends State<AdminReviewSheet> {
  final _feedbackCtrl = TextEditingController();

  /// 'approved' / 'rejected' while that request is in flight.
  String? _submitting;
  bool _askForReason = false;

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  String? get _feedback {
    final t = _feedbackCtrl.text.trim();
    return t.isEmpty ? null : t;
  }

  Future<void> _reject() async {
    final noReason = _feedback == null;
    if (noReason) setState(() => _askForReason = true);
    final ok = await showConfirmDialog(
      context,
      title: 'رفض التقرير؟',
      body: noReason
          ? 'لم تكتب سببًا للرفض. سيُعاد فتح المهمة للمتطوع ليرسل تقريرًا جديدًا.'
          : 'سيصل سبب الرفض إلى المتطوع، ويُعاد فتح المهمة ليرسل تقريرًا جديدًا.',
      confirmLabel: 'رفض التقرير',
      isDestructive: true,
    );
    if (ok && mounted) await _submit('rejected');
  }

  Future<void> _submit(String status) async {
    if (_submitting != null) return;
    HapticFeedback.mediumImpact();
    setState(() => _submitting = status);
    final error = await context.read<AdminReportsCubit>().reviewReport(
      reportId: widget.report.id,
      status: status,
      feedback: _feedback,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() => _submitting = null);
      Toast.error.show(context, title: error);
      return;
    }
    Toast.success.show(
      context,
      title: status == 'approved' ? 'تم اعتماد التقرير' : 'تم رفض التقرير',
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final isPending = report.status == 'pending';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: ColorManager.canvas,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Radii.sheet),
            ),
          ),
          child: Column(
            children: [
              _Header(report: report),
              const Divider(height: 1, color: ColorManager.line),
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: EdgeInsetsDirectional.fromSTEB(
                    Space.gutter,
                    Space.vl,
                    Space.gutter,
                    Space.vxl,
                  ),
                  children: [
                    _FactsCard(report: report),
                    SizedBox(height: Space.vl),
                    ReviewDetailCard(
                      title: 'ملخص المهمة',
                      content: report.summary.isEmpty ? '—' : report.summary,
                    ),
                    if (_hasText(report.challenges)) ...[
                      SizedBox(height: Space.vm),
                      ReviewDetailCard(
                        title: 'التحديات',
                        content: report.challenges!,
                      ),
                    ],
                    if (_hasText(report.additionalNotes)) ...[
                      SizedBox(height: Space.vm),
                      ReviewDetailCard(
                        title: 'ملاحظات إضافية',
                        content: report.additionalNotes!,
                      ),
                    ],
                    if (_hasText(report.adminFeedback)) ...[
                      SizedBox(height: Space.vm),
                      ReviewDetailCard(
                        title: 'ملاحظات المشرف',
                        content: report.adminFeedback!,
                        highlighted: true,
                      ),
                    ],
                    if (isPending) ...[
                      SizedBox(height: Space.vxl),
                      PrimaryTextFF(
                        controller: _feedbackCtrl,
                        label: 'ملاحظات المراجعة (اختياري)',
                        hint: 'اكتب ملاحظاتك للمتطوع…',
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        onChanged: (v) {
                          if (_askForReason && v.trim().isNotEmpty) {
                            setState(() => _askForReason = false);
                          }
                        },
                      ),
                      SizedBox(height: Space.vxs),
                      AnimatedSwitcher(
                        duration: AppMotion.of(context, AppMotion.fast),
                        child: _askForReason
                            ? Text(
                                'اكتب سبب الرفض ليعرف المتطوع ما يحتاج إلى تحسينه.',
                                key: const ValueKey('reason'),
                                style: AppText.caption(
                                  color: ColorManager.warning,
                                ),
                              )
                            : Text(
                                'تصل ملاحظاتك إلى المتطوع مع نتيجة المراجعة.',
                                key: const ValueKey('helper'),
                                style: AppText.caption(),
                              ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isPending)
                _ActionBar(
                  submitting: _submitting,
                  onReject: _reject,
                  onApprove: () => _submit('approved'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _hasText(String? s) => s != null && s.trim().isNotEmpty;
}

class _Header extends StatelessWidget {
  const _Header({required this.report});
  final AdminReportEntity report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Space.vm),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: ColorManager.line,
            borderRadius: BorderRadius.circular(Radii.small),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            Space.gutter,
            Space.vm,
            Space.xs,
            Space.vm,
          ),
          child: Row(
            children: [
              VolunteerAvatar(
                name: report.volunteerName,
                url: report.volunteerAvatarUrl,
                size: 44,
              ),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.taskTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title(),
                    ),
                    Text(
                      '${report.volunteerName} · ${DateAr.date(report.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Space.s),
              StatusBadge(status: report.status, compact: true),
              IconButton(
                tooltip: 'إغلاق',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(AppIcons.x, color: ColorManager.inkMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FactsCard extends StatelessWidget {
  const _FactsCard({required this.report});
  final AdminReportEntity report;

  @override
  Widget build(BuildContext context) {
    const divider = Divider(height: 1, color: ColorManager.line);
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: ColorManager.line),
      ),
      child: Column(
        children: [
          ReviewInfoRow(
            icon: AppIcons.star,
            label: 'التقييم',
            trailing: RatingStars(rating: report.rating, size: AppSizes.iconM),
          ),
          if (report.attendeesCount != null) ...[
            divider,
            ReviewInfoRow(
              icon: AppIcons.group,
              label: 'عدد الحضور',
              value: '${report.attendeesCount}',
            ),
          ],
          divider,
          ReviewInfoRow(
            icon: AppIcons.done,
            label: 'توزيع المواد',
            value: report.materialsDistributed ? 'نعم' : 'لا',
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.submitting,
    required this.onReject,
    required this.onApprove,
  });

  final String? submitting;
  final VoidCallback onReject;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    final busy = submitting != null;
    final rejecting = submitting == 'rejected';
    return Container(
      decoration: const BoxDecoration(
        color: ColorManager.surface,
        border: Border(top: BorderSide(color: ColorManager.line)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(
        Space.gutter,
        Space.vm,
        Space.gutter,
        Space.vm + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: AppSizes.touch,
              child: OutlinedButton(
                onPressed: busy ? null : onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorManager.error,
                  side: const BorderSide(color: ColorManager.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.input),
                  ),
                ),
                child: rejecting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: ColorManager.error,
                        ),
                      )
                    : Text(
                        'رفض',
                        style: getSemiBoldStyle(
                          fontSize: FontSize.s15,
                          color: busy
                              ? ColorManager.inkFaint
                              : ColorManager.error,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: Space.m),
          Expanded(
            flex: 2,
            child: PrimaryElevatedButton(
              title: 'اعتماد التقرير',
              icon: AppIcons.done,
              height: AppSizes.touch,
              backGroundColor: ColorManager.sprout,
              isLoading: submitting == 'approved',
              onPress: busy ? () {} : onApprove,
            ),
          ),
        ],
      ),
    );
  }
}
