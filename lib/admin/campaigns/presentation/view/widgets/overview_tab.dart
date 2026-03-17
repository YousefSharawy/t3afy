import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'overview_info_card.dart';
import 'overview_info_row.dart';
import 'overview_info_row_with_check.dart';
import 'overview_divider.dart';
import 'overview_section_card.dart';
import 'overview_list_card.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSize.s16),
      children: [
        OverviewInfoCard(
          children: [
            OverviewInfoRow(
              icon: IconAssets.location,
              label: 'المنطقة',
              value: detail.locationName ?? '—',
            ),
            const OverviewDivider(),
            OverviewInfoRow(
              icon: IconAssets.calendar,
              label: 'التاريخ',
              value: detail.date,
            ),
            const OverviewDivider(),
            OverviewInfoRow(
              icon: IconAssets.target,
              label: 'النوع',
              value: detail.type,
            ),
            if (detail.supervisorName != null) ...[
              const OverviewDivider(),
              OverviewInfoRow(
                icon: IconAssets.volHome,
                label: 'المشرف',
                value: detail.supervisorName!,
              ),
            ],
            if (detail.supervisorPhone != null) ...[
              OverviewInfoRow(
                icon: IconAssets.phone,
                label: 'هاتف المشرف',
                value: detail.supervisorPhone!,
              ),
            ],
          ],
        ),
        SizedBox(height: AppHeight.s16),
        OverviewInfoCard(
          children: [
            OverviewInfoRow(
              icon: IconAssets.group,
              label: 'المتطوعون',
              value:
                  '${detail.members.length} من ${detail.targetBeneficiaries > 0 ? detail.targetBeneficiaries : '—'}',
            ),
            OverviewInfoRow(
              icon: IconAssets.target,
              label: 'الهدف',
              value: '${detail.targetBeneficiaries} مستفيد',
            ),
            OverviewInfoRowWithCheck(
              icon: IconAssets.target,
              label: 'تم الوصول',
              value: '${detail.reachedBeneficiaries} مستفيد',
              achieved: detail.reachedBeneficiaries > 0,
            ),
          ],
        ),
        if (detail.description != null && detail.description!.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          OverviewSectionCard(title: 'الوصف', body: detail.description!),
        ],
        if (detail.notes != null && detail.notes!.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          OverviewSectionCard(title: 'ملاحظات', body: detail.notes!),
        ],
        if (detail.objectives.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          OverviewListCard(
            title: 'الأهداف',
            items: detail.objectives.map((o) => o.title).toList(),
            icon: Icons.check_box_outlined,
          ),
        ],
        if (detail.supplies.isNotEmpty) ...[
          SizedBox(height: AppHeight.s16),
          Container(
            padding: EdgeInsets.all(AppSize.s16),
            decoration: BoxDecoration(
              color: ColorManager.blueOne800,
              borderRadius: BorderRadius.circular(AppRadius.s12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المستلزمات',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s13,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppHeight.s12),
                ...detail.supplies.map(
                  (s) => Padding(
                    padding: EdgeInsets.only(bottom: AppHeight.s8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14.r,
                          color: ColorManager.cyanPrimary,
                        ),
                        SizedBox(width: AppWidth.s8),
                        Expanded(
                          child: Text(
                            s.name,
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppWidth.s8,
                            vertical: AppHeight.s2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.blueOne700,
                            borderRadius: BorderRadius.circular(AppRadius.s8),
                          ),
                          child: Text(
                            '${s.quantity}',
                            style: getMediumStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s11,
                              color: ColorManager.blueTwo200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: AppHeight.s80),
      ],
    );
  }
}
