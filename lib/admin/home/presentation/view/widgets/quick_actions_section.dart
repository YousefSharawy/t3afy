import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(IconAssets.fast,width: AppWidth.s24,height: AppHeight.s24,),
            SizedBox(width: AppWidth.s8,),
            Text("اجراءات سريعة",style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: ColorManager.blueOne900
            ),),
          ],
        ),
        SizedBox(height: AppHeight.s16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
          child: Row(
            children: [ 
              _ActionCard(
                icon:IconAssets.announcement,
                label: 'إرسال إعلان',
                onTap: onSendAnnouncement,
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
    required this.label,
    this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppWidth.s107,
        height: AppHeight.s86,
        padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
        decoration: BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          mainAxisAlignment: .spaceBetween,
          children: [
            Image.asset(icon),
            Text(
              label,
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
