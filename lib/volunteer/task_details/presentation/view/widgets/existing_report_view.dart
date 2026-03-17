import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ExistingReportView extends StatelessWidget {
  const ExistingReportView({super.key, required this.report});

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
          ColorManager.amber400,
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
                color: ColorManager.blueOne700,
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
                      color: ColorManager.cyanPrimary,
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
