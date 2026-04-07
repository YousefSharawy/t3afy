import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ReportLabeledField(
              label: 'ملخص المهمة',
              controller: summaryCtrl,
              maxLines: 4,
              hint: 'اكتب ملخصاً عما تم إنجازه...',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
            ),
            SizedBox(height: AppHeight.s16),
            ReportLabeledField(
              label: 'التحديات التي واجهتها',
              controller: challengesCtrl,
              maxLines: 3,
              hint: 'اذكر أي تحديات أو عقبات (اختياري)',
            ),
            SizedBox(height: AppHeight.s16),
            ReportLabeledField(
              label: 'عدد الحضور',
              controller: attendeesCtrl,
              hint: 'عدد المستفيدين أو الحضور',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppHeight.s16),
            ReportLabeledField(
              label: 'المواد الموزعة',
              controller: materialsCtrl,
              hint: 'المستلزمات التي تم توزيعها (اختياري)',
            ),
            SizedBox(height: AppHeight.s16),
            ReportStarRating(rating: rating, onRatingChanged: onRatingChanged),
            SizedBox(height: AppHeight.s16),
            ReportLabeledField(
              label: 'ملاحظات إضافية',
              controller: notesCtrl,
              maxLines: 3,
              hint: 'أي ملاحظات أخرى (اختياري)',
            ),
            SizedBox(height: AppHeight.s24),
            PrimaryElevatedButton(
              title: 'إرسال',
              onPress: isSubmitting
                  ? () {}
                  : () {
                      HapticFeedback.mediumImpact();
                      onSubmit();
                    },
              textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: Colors.white,
              ),
              titleWidget: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : null,
            ),
            SizedBox(height: AppHeight.s12),
            PrimaryElevatedButton(
              title: 'إلغاء',
              onPress: onCancel,
              backGroundColor: ColorManager.natural200,
              textStyle: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: AppHeight.s24),
          ],
        ),
      ),
    );
  }
}
