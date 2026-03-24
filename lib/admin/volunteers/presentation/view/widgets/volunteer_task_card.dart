import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

class VolunteerTaskCard extends StatelessWidget {
  const VolunteerTaskCard({super.key, required this.task});

  final VolunteerTaskAssignmentEntity task;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        children: [
          Image.asset(
            _taskIcon(task.title),
            width: AppWidth.s24,
            height: AppHeight.s24,
            fit: BoxFit.cover,
          ),
          SizedBox(width: AppWidth.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title.isNotEmpty ? task.title : 'مهمة',
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.natural700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.assignedAt != null)
                  Text(
                    _formatDate(task.assignedAt!),
                    style: getRegularStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s10,
                      color: ColorManager.natural400,
                    ),
                  ),
              ],
            ),
          ),
          StatusBadge(status: task.status),
        ],
      ),
    );
  }

  String _taskIcon(String title) {
    if (title.contains('مستشفي')) return IconAssets.hospital;
    if (title.contains('توزيع')) return IconAssets.campaigns;
    return IconAssets.camp;
  }

  static const _months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  String _formatDate(DateTime dt) {
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }
}
