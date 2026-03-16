import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.name,
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppHeight.s8),
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
                        SizedBox(width: AppWidth.s8),
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
                    SizedBox(height: AppHeight.s8),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < details.rating.floor()
                              ? Icons.star
                              : (i < details.rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                          color: const Color(0xFFFBBF24),
                          size: 14.r,
                        );
                      })
                        ..add(
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: AppWidth.s4,
                            ),
                            child: Text(
                              details.rating.toStringAsFixed(1),
                              style: getRegularStyle(
                                fontFamily: FontConstants.fontFamily,
                                fontSize: FontSize.s11,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFF1F2E4F),
                backgroundImage: details.avatarUrl != null
                    ? NetworkImage(details.avatarUrl!)
                    : null,
                child: details.avatarUrl == null
                    ? Icon(Icons.person, color: Colors.white54, size: 28.r)
                    : null,
              ),
            ],
          ),
          SizedBox(height: AppHeight.s16),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  value: '${details.totalTasks}',
                  label: 'مهمة',
                  icon: Icons.emoji_events_outlined,
                  color: const Color(0xFF22C55E),
                  bg: const Color(0xFF14532D),
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: _StatBox(
                  value: '${details.totalHours}',
                  label: 'ساعة',
                  icon: Icons.access_time,
                  color: const Color(0xFF60A5FA),
                  bg: const Color(0xFF1E3A5F),
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: _StatBox(
                  value: '${details.level}',
                  label: 'مستوى',
                  icon: Icons.military_tech_outlined,
                  color: const Color(0xFFFBBF24),
                  bg: const Color(0xFF451A03),
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
    required this.color,
    required this.bg,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s8,
        horizontal: AppWidth.s8,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16.r),
          SizedBox(height: AppHeight.s4),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: color,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
