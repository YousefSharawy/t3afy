import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerTaskCard extends StatelessWidget {
  const VolunteerTaskCard({super.key, required this.task});

  final VolunteerTaskAssignmentEntity task;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'completed';
    final statusColor = isCompleted
        ? const Color(0xFF22C55E)
        : const Color(0xFF60A5FA);
    final statusBg = isCompleted
        ? const Color(0xFF14532D)
        : ColorManager.navyLight;
    final statusLabel = isCompleted ? 'مكتملة' : 'نشيطة';

    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppWidth.s8),
            decoration: BoxDecoration(
              color: ColorManager.navyCard,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Icon(
              Icons.task_alt_outlined,
              color: ColorManager.blueOne300,
              size: 18.r,
            ),
          ),
          SizedBox(width: AppWidth.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title.isNotEmpty ? task.title : 'مهمة',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.blueOne50,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.assignedAt != null)
                  Text(
                    _formatDate(task.assignedAt!),
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: ColorManager.blueOne300,
                    ),
                  ),
              ],
            ),
          ),
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
              statusLabel,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
