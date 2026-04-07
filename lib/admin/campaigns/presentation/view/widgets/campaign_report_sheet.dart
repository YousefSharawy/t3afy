import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'report_divider.dart';

class CampaignReportSheet extends StatelessWidget {
  const CampaignReportSheet({super.key, required this.detail});

  final CampaignDetailEntity detail;

  static const _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  String _formatDate(String raw) {
    try {
      final parts = raw.split('-');
      if (parts.length != 3) return raw;
      final day = int.parse(parts[2]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[0]);
      return '$day ${_arabicMonths[month - 1]} $year';
    } catch (_) {
      return raw;
    }
  }

  String _formatTime(String? raw) {
    if (raw == null) return '—';
    // strip seconds if present (HH:MM:SS -> HH:MM)
    final clean = raw.length > 5 ? raw.substring(0, 5) : raw;
    try {
      final parts = clean.split(':');
      var hour = int.parse(parts[0]);
      final minute = parts[1];
      final suffix = hour < 12 ? 'ص' : 'م';
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }
      return '$hour:$minute $suffix';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeValue = (detail.timeStart != null && detail.timeEnd != null)
        ? '${_formatTime(detail.timeStart)} - ${_formatTime(detail.timeEnd)}'
        : _formatTime(detail.timeStart ?? detail.timeEnd);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSize.s20,
          AppSize.s12,
          AppSize.s20,
          MediaQuery.of(context).padding.bottom + AppSize.s20,
        ),
        decoration: BoxDecoration(
          color: ColorManager.natural50,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: AppWidth.s39,
                height: AppHeight.s3,
                decoration: BoxDecoration(
                  color: ColorManager.natural500,
                  borderRadius: BorderRadius.circular(AppRadius.s20),
                ),
              ),
            ),
            SizedBox(height: AppHeight.s12),
            // Header — centered icon + title
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    IconAssets.performance,
                    width: 24.r,
                    height: 24.r,
                  ),
                  SizedBox(width: AppWidth.s8),
                  Text(
                    'تقرير الحملة',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: ColorManager.natural900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppHeight.s20),

            // Info rows
            _ReportRow(
              iconAsset: IconAssets.target,
              label: 'الهدف المحدد',
              value: '${detail.targetBeneficiaries} مستفيد',
            ),
            const ReportDivider(),
            _ReportRow(
              iconAsset: IconAssets.done,
              label: 'تم الوصول اليهم',
              value: '${detail.reachedBeneficiaries} مستفيد',
            ),
            const ReportDivider(),
            _ReportRow(
              iconAsset: IconAssets.calendar,
              label: 'تاريخ الحملة',
              value: _formatDate(detail.date),
            ),
            const ReportDivider(),
            _ReportRow(
              iconAsset: IconAssets.alarm,
              label: 'الوقت',
              value: timeValue,
            ),
            const ReportDivider(),
            _ReportRow(
              iconAsset: IconAssets.location,
              label: 'المنطقة',
              value: detail.locationName ?? '—',
            ),
            const ReportDivider(),
            _ReportRow(
              iconAsset: IconAssets.group2,
              label: 'فريق العمل',
              value: '${detail.members.length} متطوع',
            ),

            if (detail.objectives.isNotEmpty) ...[
              SizedBox(height: AppHeight.s16),
              Divider(color: ColorManager.natural200, height: 1),
              SizedBox(height: AppHeight.s16),

              // Objectives header
              Row(
                children: [
                  Image.asset(IconAssets.target, width: 22.r, height: 22.r),
                  SizedBox(width: AppWidth.s8),
                  Text(
                    'الأهداف',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s16,
                      color: ColorManager.natural900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppHeight.s12),

              // Objectives list
              for (final objective in detail.objectives)
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: AppHeight.s8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: ColorManager.success,
                        size: 18.r,
                      ),
                      SizedBox(width: AppWidth.s8),
                      Expanded(
                        child: Text(
                          objective.title,
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s14,
                            color: ColorManager.natural900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            SizedBox(height: AppHeight.s20),

            PrimaryElevatedButton(
              title: 'إغلاق التقارير',
              onPress: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.iconAsset,
    required this.label,
    required this.value,
  });

  final String iconAsset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
      child: Row(
        children: [
          Image.asset(iconAsset, width: 18.r, height: 18.r),
          SizedBox(width: AppWidth.s7),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural400,
            ),
          ),
        ],
      ),
    );
  }
}
