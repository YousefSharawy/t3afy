import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'volunteer_badge.dart';

class VolunteerCard extends StatelessWidget {
  const VolunteerCard({super.key, required this.volunteer});

  final AdminVolunteerEntity volunteer;

  @override
  Widget build(BuildContext context) {
    final status = volunteer.status;
    final (statusColor, statusBg) = _statusColors(status);
    return GestureDetector(
      onTap: () => context.push('/volunteerDetails/${volunteer.id}'),
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        decoration: BoxDecoration(
          color: ColorManager.blueOne900,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppWidth.s34,
                height: AppHeight.s34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.s8)),
                  color: ColorManager.navyCard,
                ),
                child: Image.asset(IconAssets.volHome),
              ),
              SizedBox(width: AppWidth.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      volunteer.name,
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppHeight.s2),
                    Row(
                      children: [
                        Image.asset(
                          width: AppWidth.s16,
                          height: AppHeight.s16,
                          IconAssets.location,
                        ),
                        SizedBox(width: AppWidth.s4),
                        Flexible(
                          child: Text(
                            volunteer.region ?? 'غير محدد',
                            style: getRegularStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s10,
                              color: ColorManager.blueOne300,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppWidth.s16),
                        Image.asset(
                          width: AppWidth.s16,
                          height: AppHeight.s16,
                          IconAssets.star,
                        ),
                        SizedBox(width: AppWidth.s6),
                        Text(
                          volunteer.rating.toStringAsFixed(1),
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s11,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppHeight.s4),
                    Row(
                      children: [
                        VolunteerBadge(
                          icon: Icons.check_circle_outline,
                          label: '${volunteer.totalTasks} مهمة',
                          color: const Color(0xFF22C55E),
                          bg: const Color(0xFF14532D),
                        ),
                        SizedBox(width: AppWidth.s8),
                        VolunteerBadge(
                          icon: Icons.access_time,
                          label: '${volunteer.totalHours} ساعة',
                          color: const Color(0xFF60A5FA),
                          bg: ColorManager.navyLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s8,
                  vertical: AppHeight.s4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(AppRadius.s6),
                ),
                child: Text(
                  status,
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color) _statusColors(String status) {
    switch (status) {
      case 'نشط':
        return (const Color(0xFF22C55E), const Color(0xFF14532D));
      case 'قيد المراجعة':
        return (ColorManager.amber400, const Color(0xFF451A03));
      default:
        return (const Color(0xFFB2B2B2), const Color(0xFF1F2937));
    }
  }
}
