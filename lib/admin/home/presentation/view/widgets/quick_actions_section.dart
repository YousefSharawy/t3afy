import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    this.onNewCampaign,
    this.onFullReport,
    this.onSendAnnouncement,
  });

  final VoidCallback? onNewCampaign;
  final VoidCallback? onFullReport;
  final VoidCallback? onSendAnnouncement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bolt_rounded,
              color: ColorManager.blueTwo200,
              size: 20.r,
            ),
            SizedBox(width: AppWidth.s6),
            Text(
              'اجراءات سريعة',
              style: getSemiBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
          child: Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.add_rounded,
                  iconBgColor: Colors.blue,
                  label: 'حملة جديدة',
                  onTap: onNewCampaign,
                ),
              ),
              SizedBox(width: AppWidth.s10),
              Expanded(
                child: _ActionCard(
                  icon: Icons.assessment_rounded,
                  iconBgColor: Colors.blue,
                  label: 'تقرير شامل',
                  onTap: onFullReport,
                ),
              ),
              SizedBox(width: AppWidth.s10),
              Expanded(
                child: _ActionCard(
                  icon: Icons.campaign_rounded,
                  iconBgColor: Colors.pink,
                  label: 'إرسال إعلان',
                  onTap: onSendAnnouncement,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconBgColor,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color iconBgColor;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppHeight.s16),
        decoration: BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: ColorManager.blueOne700),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: iconBgColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconBgColor, size: 24.r),
            ),
            SizedBox(height: AppHeight.s8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s11,
                color: ColorManager.blueTwo100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
