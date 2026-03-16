import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerDetailsHeader extends StatelessWidget {
  const VolunteerDetailsHeader({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBg) = _statusColors(details.status);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppWidth.s16),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: AppWidth.s48,
                    height: AppHeight.s43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                      color: const Color(0xFF006AB5).withValues(alpha: .39),
                      border: Border.all(
                        color: ColorManager.blueThree600,
                        width: 1.sp,
                      ),
                    ),
                    child: Image.asset(IconAssets.volHome),
                  ),
                ],
              ),
              SizedBox(width: AppWidth.s8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: .start,
                children: [
                  Text(
                    details.name,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppHeight.s7),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppWidth.s8,
                          vertical: AppHeight.s3,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(AppRadius.s6),
                        ),
                        child: Text(
                          details.status,
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: statusColor,
                          ),
                        ),
                      ),
                      SizedBox(width: AppWidth.s13),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppWidth.s8,
                          vertical: AppHeight.s3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A5F),
                          borderRadius: BorderRadius.circular(AppRadius.s6),
                        ),
                        child: Text(
                          'المستوى ${details.level}',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s10,
                            color: const Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Image.asset(IconAssets.star);
                      }),
                      SizedBox(width: AppWidth.s8),
                      Text(
                        details.rating.toStringAsFixed(1),
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s12,
                          color: ColorManager.blueOne50,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.s8),
               
                ],
              ),
              
          
              // Stats row
            ],
          ),
             Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      value: '${details.totalTasks}',
                      label: 'مهمة',
                      icon: IconAssets.done,
                    ),
                  ),
                  SizedBox(width: AppWidth.s8),
                  Expanded(
                    child: _StatBox(
                      value: '${details.totalHours}',
                      label: 'ساعة',
                      icon: IconAssets.hours,
                    ),
                  ),
                  SizedBox(width: AppWidth.s8),
                  Expanded(
                    child: _StatBox(
                      value: '${details.level}',
                      label: 'مستوى',
                      icon: IconAssets.trophy,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  (Color, Color) _statusColors(String status) {
    if (status == 'نشط') {
      return (const Color(0xFF22C55E), const Color(0xFF14532D));
    }
    return (const Color(0xFFB2B2B2), const Color(0xFF1F2937));
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppWidth.s99,
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s8,
        horizontal: AppWidth.s32,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne700,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Column(
        children: [
          Image.asset(icon,width: AppWidth.s24,height: AppHeight.s24,),
          SizedBox(height: AppHeight.s4),
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.blueOne50,
            ),
          ),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: ColorManager.blueOne100,
            ),
          ),
        ],
      ),
    );
  }
}

 