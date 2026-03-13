import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import 'admin_review_sheet.dart';

class AdminReportCard extends StatelessWidget {
  const AdminReportCard({
    super.key,
    required this.report,
    required this.onUpdated,
  });

  final Map<String, dynamic> report;
  final VoidCallback onUpdated;

  @override
  Widget build(BuildContext context) {
    final status = report['status'] as String? ?? 'pending';
    final taskTitle =
        (report['tasks'] as Map<String, dynamic>?)?['title'] as String? ??
        'مهمة';
    final volunteerName =
        (report['volunteers'] as Map<String, dynamic>?)?['full_name']
            as String? ??
        'متطوع';
    final rating = report['rating'] as int? ?? 0;
    final createdAt = report['created_at'] != null
        ? DateTime.tryParse(report['created_at'] as String)
        : null;

    final (statusLabel, statusColor) = switch (status) {
      'approved' => ('موافق عليه', const Color(0xFF4CAF50)),
      'rejected' => ('مرفوض', Colors.red),
      _ => ('قيد المراجعة', const Color(0xFFFBBF24)),
    };

    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) =>
              AdminReviewSheet(report: report, onUpdated: onUpdated),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s12),
        padding: EdgeInsets.all(AppSize.s16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0C203B), Color(0xFF143764)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppRadius.s16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s10,
                    vertical: AppHeight.s4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s11,
                      color: statusColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  taskTitle,
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s8),
            Row(
              children: [
                if (createdAt != null)
                  Text(
                    '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s11,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: i < rating
                          ? const Color(0xFFFBBF24)
                          : Colors.white.withValues(alpha: 0.2),
                      size: 14.r,
                    ),
                  ),
                ),
                SizedBox(width: AppWidth.s8),
                Text(
                  volunteerName,
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
