import 'package:flutter/material.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/core/utils/date_ar.dart';

class CampaignReportSheet extends StatelessWidget {
  const CampaignReportSheet({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(detail.date);
    final time = DateAr.timeRange(detail.timeStart, detail.timeEnd);
    final rows = <(IconData, String, String)>[
      (AppIcons.target, 'الهدف المحدد', '${detail.targetBeneficiaries} مستفيد'),
      (AppIcons.done, 'تم الوصول إليهم', '${detail.reachedBeneficiaries} مستفيد'),
      (AppIcons.calendar, 'تاريخ الحملة', date == null ? detail.date : DateAr.date(date)),
      (AppIcons.alarm, 'الوقت', time.isEmpty ? '—' : time),
      (AppIcons.location, 'المنطقة', detail.locationName ?? '—'),
      (AppIcons.group2, 'فريق العمل', '${detail.members.length} متطوع'),
    ];

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.vm,
        Space.gutter,
        Space.vl + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorManager.line,
                  borderRadius: BorderRadius.circular(Radii.chip),
                ),
              ),
            ),
            SizedBox(height: Space.vl),
            Text('تقرير الحملة', style: AppText.title()),
            SizedBox(height: Space.vm),
            for (final (i, r) in rows.indexed) ...[
              if (i > 0) const Divider(height: 1, color: ColorManager.line),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Space.vm),
                child: Row(
                  children: [
                    Icon(r.$1, size: AppSizes.iconM, color: ColorManager.brand),
                    SizedBox(width: Space.s),
                    Text(r.$2, style: AppText.label()),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        r.$3,
                        textAlign: TextAlign.end,
                        style: getNumericStyle(
                          fontSize: FontSize.s13,
                          color: ColorManager.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (detail.objectives.isNotEmpty) ...[
              SizedBox(height: Space.vl),
              Text('الأهداف', style: AppText.bodyStrong()),
              SizedBox(height: Space.vs),
              for (final o in detail.objectives)
                Padding(
                  padding: EdgeInsets.only(bottom: Space.vs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(AppIcons.done2, size: AppSizes.iconM, color: ColorManager.sprout),
                      SizedBox(width: Space.s),
                      Expanded(child: Text(o.title, style: AppText.body())),
                    ],
                  ),
                ),
            ],
            SizedBox(height: Space.vl),
            PrimaryElevatedButton(
              title: 'إغلاق',
              onPress: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
