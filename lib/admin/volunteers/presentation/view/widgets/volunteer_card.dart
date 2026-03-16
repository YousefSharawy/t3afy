import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerCard extends StatelessWidget {
  const VolunteerCard({super.key, required this.volunteer});

  final AdminVolunteerEntity volunteer;

  @override
  Widget build(BuildContext context) {
    final status = volunteer.status;
    final (statusColor, statusBg) = _statusColors(status);

    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C203B),
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: const Color(0xFF1E3A5F)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.s14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar (rightmost in RTL)
            _Avatar(
              avatarUrl: volunteer.avatarUrl,
              name: volunteer.name,
              isActive: volunteer.isActiveNow,
            ),
            SizedBox(width: AppWidth.s12),
            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    volunteer.name,
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppHeight.s4),
                  // Region + Rating row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white54,
                        size: 13,
                      ),
                      SizedBox(width: AppWidth.s3),
                      Flexible(
                        child: Text(
                          volunteer.region ?? 'غير محدد',
                          style: getRegularStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s11,
                            color: Colors.white54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: AppWidth.s10),
                      const Icon(Icons.star, color: Color(0xFFFFC107), size: 13),
                      SizedBox(width: AppWidth.s3),
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
                  SizedBox(height: AppHeight.s8),
                  // Badges row
                  Row(
                    children: [
                      _Badge(
                        icon: Icons.check_circle_outline,
                        label: '${volunteer.totalTasks} مهمة',
                        color: const Color(0xFF22C55E),
                        bg: const Color(0xFF14532D),
                      ),
                      SizedBox(width: AppWidth.s8),
                      _Badge(
                        icon: Icons.access_time,
                        label: '${volunteer.totalHours} ساعة',
                        color: const Color(0xFF60A5FA),
                        bg: const Color(0xFF1E3A5F),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: AppWidth.s8),
            // Status badge (top-left corner in LTR / top-right visually becomes opposite in RTL)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s8,
                vertical: AppHeight.s4,
              ),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(AppRadius.s20),
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
    );
  }

  (Color, Color) _statusColors(String status) {
    switch (status) {
      case 'نشط':
        return (const Color(0xFF22C55E), const Color(0xFF14532D));
      case 'قيد المراجعة':
        return (const Color(0xFFFBBF24), const Color(0xFF451A03));
      default:
        return (const Color(0xFF9CA3AF), const Color(0xFF1F2937));
    }
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.avatarUrl,
    required this.name,
    required this.isActive,
  });

  final String? avatarUrl;
  final String name;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final avatar = (avatarUrl != null && avatarUrl!.isNotEmpty)
        ? CircleAvatar(
            radius: AppSize.s24,
            backgroundImage: NetworkImage(avatarUrl!),
            backgroundColor: const Color(0xFF1E3A5F),
          )
        : CircleAvatar(
            radius: AppSize.s24,
            backgroundColor: const Color(0xFF1E3A5F),
            child: const Icon(Icons.person, color: Colors.white70, size: 24),
          );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF22C55E) : const Color(0xFF6B7280),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0C203B), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s8,
        vertical: AppHeight.s3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.s20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          SizedBox(width: AppWidth.s4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
