import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_detail_entity.dart';

class CampaignReportSheet extends StatelessWidget {
  const CampaignReportSheet({super.key, required this.detail});

  final CampaignDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final timeValue = (detail.timeStart != null && detail.timeEnd != null)
        ? '${detail.timeStart} - ${detail.timeEnd}'
        : detail.timeStart ?? detail.timeEnd ?? '—';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSize.s20,
          AppSize.s12,
          AppSize.s20,
          AppSize.s24,
        ),
        decoration: BoxDecoration(
          color: ColorManager.blueOne800,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.blueOne700,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: AppHeight.s16),

            // Title row
            Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.s10),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: const Color(0xFF8B5CF6),
                    size: 20.r,
                  ),
                ),
                SizedBox(width: AppWidth.s10),
                Text(
                  'تقرير الحملة',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s16),

            // Info card
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s16,
                vertical: AppSize.s4,
              ),
              decoration: BoxDecoration(
                color: ColorManager.blueOne900,
                borderRadius: BorderRadius.circular(AppRadius.s12),
                border: Border.all(color: ColorManager.blueOne700),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF0EA5E9),
                    label: 'الهدف المحدد',
                    value: '${detail.targetBeneficiaries} مستفيد',
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.check_circle_outline,
                    iconColor: const Color(0xFF10B981),
                    label: 'تم الوصول اليهم',
                    value: '${detail.reachedBeneficiaries} مستفيد',
                    valueColor: const Color(0xFF10B981),
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    label: 'تاريخ الحملة',
                    value: detail.date,
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.access_time_outlined,
                    iconColor: const Color(0xFF0EA5E9),
                    label: 'الوقت',
                    value: timeValue,
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    iconColor: const Color(0xFFEF4444),
                    label: 'المنطقة',
                    value: detail.locationName ?? '—',
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.group_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    label: 'فريق العمل',
                    value: '${detail.members.length} متطوع',
                  ),
                ],
              ),
            ),

            if (detail.objectives.isNotEmpty) ...[
              SizedBox(height: AppHeight.s16),

              // Objectives section header
              Text(
                'الأهداف',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppHeight.s8),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s16,
                  vertical: AppSize.s4,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.blueOne900,
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  border: Border.all(color: ColorManager.blueOne700),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < detail.objectives.length; i++) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppHeight.s10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF10B981),
                              size: 18.r,
                            ),
                            SizedBox(width: AppWidth.s10),
                            Expanded(
                              child: Text(
                                detail.objectives[i].title,
                                style: getMediumStyle(
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontSize.s13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < detail.objectives.length - 1) _Divider(),
                    ],
                  ],
                ),
              ),
            ],

            SizedBox(height: AppHeight.s20),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.blueOne700,
                  padding: EdgeInsets.symmetric(vertical: AppHeight.s14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'إغلاق التقارير',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18.r),
          SizedBox(width: AppWidth.s8),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: valueColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: ColorManager.blueOne700,
    );
  }
}
