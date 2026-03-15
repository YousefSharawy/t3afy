import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

class AdminReportCard extends StatelessWidget {
  const AdminReportCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  final AdminReportEntity report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = switch (report.status) {
      'approved' => ('موافق عليه', const Color(0xFF4CAF50)),
      'rejected' => ('مرفوض', Colors.red),
      _ => ('قيد المراجعة', const Color(0xFFFBBF24)),
    };

    return GestureDetector(
      onTap: onTap,
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
                  report.taskTitle,
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
                Text(
                  '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
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
                      i < report.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: i < report.rating
                          ? const Color(0xFFFBBF24)
                          : Colors.white.withValues(alpha: 0.2),
                      size: 14.r,
                    ),
                  ),
                ),
                SizedBox(width: AppWidth.s8),
                Text(
                  report.volunteerName,
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
