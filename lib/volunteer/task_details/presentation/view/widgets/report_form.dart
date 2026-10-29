import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

import 'report_labeled_field.dart';
import 'report_star_rating.dart';

class ReportForm extends StatelessWidget {
  const ReportForm({
    super.key,
    required this.formKey,
    required this.summaryCtrl,
    required this.challengesCtrl,
    required this.attendeesCtrl,
    required this.materialsCtrl,
    required this.notesCtrl,
    required this.rating,
    required this.isSubmitting,
    required this.onRatingChanged,
    required this.onSubmit,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController summaryCtrl;
  final TextEditingController challengesCtrl;
  final TextEditingController attendeesCtrl;
  final TextEditingController materialsCtrl;
  final TextEditingController notesCtrl;
  final int rating;
  final bool isSubmitting;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Space.vl);
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(
        Space.gutter,
        Space.vs,
        Space.gutter,
        Space.vl,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReportLabeledField(
              label: 'ملخص المهمة',
              isRequired: true,
              controller: summaryCtrl,
              maxLines: 4,
              hint: 'اكتب ملخصاً عما تم إنجازه...',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
            ),
            gap,
            ReportLabeledField(
              label: 'التحديات التي واجهتها',
              controller: challengesCtrl,
              maxLines: 3,
              hint: 'اذكر أي تحديات أو عقبات (اختياري)',
            ),
            gap,
            ReportLabeledField(
              label: 'عدد الحضور',
              controller: attendeesCtrl,
              hint: 'عدد المستفيدين أو الحضور',
              keyboardType: TextInputType.number,
            ),
            gap,
            ReportLabeledField(
              label: 'المواد الموزعة',
              controller: materialsCtrl,
              hint: 'المستلزمات التي تم توزيعها (اختياري)',
            ),
            gap,
            ReportStarRating(rating: rating, onRatingChanged: onRatingChanged),
            gap,
            ReportLabeledField(
              label: 'ملاحظات إضافية',
              controller: notesCtrl,
              maxLines: 3,
              hint: 'أي ملاحظات أخرى (اختياري)',
            ),
            SizedBox(height: Space.vxl),
            PrimaryElevatedButton(
              title: 'إرسال التقرير',
              icon: AppIcons.send,
              isLoading: isSubmitting,
              onPress: () {
                HapticFeedback.mediumImpact();
                onSubmit();
              },
            ),
            SizedBox(height: Space.vs),
            TextButton(
              onPressed: isSubmitting ? null : onCancel,
              style: TextButton.styleFrom(
                foregroundColor: ColorManager.inkMuted,
                minimumSize: Size.fromHeight(AppSizes.touch),
              ),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}
