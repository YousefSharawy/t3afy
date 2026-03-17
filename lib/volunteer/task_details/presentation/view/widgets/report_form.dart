import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_star_rating.dart';
import 'package:t3afy/volunteer/task_details/presentation/view/widgets/report_submit_button.dart';
import 'form_field_widget.dart';

class ReportForm extends StatelessWidget {
  const ReportForm({
    super.key,
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
            FormFieldWidget(
              label: 'ملخص المهمة *',
              controller: summaryCtrl,
              maxLines: 4,
              hint: 'اكتب ملخصاً عما تم إنجازه...',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
            ),
            SizedBox(height: AppHeight.s16),
            FormFieldWidget(
              label: 'التحديات التي واجهتها',
              controller: challengesCtrl,
              maxLines: 3,
              hint: 'اذكر أي تحديات أو عقبات (اختياري)',
            ),
            SizedBox(height: AppHeight.s16),
            FormFieldWidget(
              label: 'عدد الحضور',
              controller: attendeesCtrl,
              hint: 'عدد المستفيدين أو الحضور',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppHeight.s16),
            FormFieldWidget(
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
                color: ColorManager.blueOne700,
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              child: Row(
                children: [
                  Switch(
                    value: objectivesMet,
                    onChanged: onObjectivesChanged,
                    activeThumbColor: ColorManager.cyanPrimary,
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
            FormFieldWidget(
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
