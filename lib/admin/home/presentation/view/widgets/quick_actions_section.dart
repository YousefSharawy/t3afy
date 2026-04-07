import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'home_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.onNewCampaign,
    this.onFullReport,
    this.onSendAnnouncement,
    this.isExportingPdf = false,
  });

  final VoidCallback? onNewCampaign;
  final VoidCallback? onFullReport;
  final VoidCallback? onSendAnnouncement;
  final bool isExportingPdf;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              IconAssets.fast,
              width: AppWidth.s24,
              height: AppHeight.s24,
            ),
            Text(
              'اجراءات سريعة',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.natural900,
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s8),
        Row(
          children: [
            Expanded(
              child: HomeActionCard(
                icon: IconAssets.add2,
                label: 'حملة جديدة',
                onTap: onNewCampaign,
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: HomeActionCard(
                icon: IconAssets.announcement,
                label: 'إرسال إعلان',
                onTap: onSendAnnouncement,
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Expanded(
              child: _ExportAnalyticsCard(
                onTap: onFullReport,
                isLoading: isExportingPdf,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExportAnalyticsCard extends StatelessWidget {
  const _ExportAnalyticsCard({this.onTap, required this.isLoading});

  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: AppHeight.s86,
        padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLoading
                ? SizedBox(
                    width: AppWidth.s24,
                    height: AppHeight.s24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorManager.primary500,
                    ),
                  )
                : Icon(
                    Icons.analytics_outlined,
                    color: ColorManager.primary500,
                    size: AppWidth.s24,
                  ),
            Text(
              'تصدير تقرير شامل',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s11,
                color: ColorManager.primary600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
