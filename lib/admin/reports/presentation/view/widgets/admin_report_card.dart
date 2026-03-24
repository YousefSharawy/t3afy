import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';

class AdminReportCard extends StatelessWidget {
  const AdminReportCard({super.key, required this.report, required this.onTap});

  final AdminReportEntity report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s12),
        padding: EdgeInsets.all(AppSize.s16),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: ColorManager.natural200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report.taskTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: ColorManager.natural900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: report.status),
              ],
            ),
            SizedBox(height: AppHeight.s8),
            Row(
              children: [
                Flexible(
                  child: Text(
                    report.volunteerName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: ColorManager.natural500,
                    ),
                  ),
                ),
                SizedBox(width: AppWidth.s8),
                Row(
                  children: List.generate(
                    5,
                    (i) => Image.asset(
                      i < report.rating
                          ? IconAssets.star
                          : IconAssets.unstar,
                      width: 14.r,
                      height: 14.r,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${report.createdAt.day} ${const ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'][report.createdAt.month - 1]} ${report.createdAt.year}',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s11,
                    color: ColorManager.natural400,
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
