import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class VolunteerTasksTab extends StatelessWidget {
  const VolunteerTasksTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppWidth.s16,
            vertical: AppHeight.s8,
          ),
          child: Row(
            children: [
              Expanded(
                child: _StatsBox(
                  label: 'منجزة',
                  value: '${details.completedTasksCount}',
                  color: const Color(0xFF22C55E),
                ),
              ),

              SizedBox(width: AppWidth.s8),
              Expanded(
                child: _StatsBox(
                  label: 'ساعة',
                  value: '${details.totalHours}',
                  color: const Color(0xFF60A5FA),
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: _StatsBox(
                  label: 'تقييم',
                  value: details.rating.toStringAsFixed(1),
                  color: const Color(0xFFFF9D2C),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: details.tasks.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد مهام مسندة',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  itemCount: details.tasks.length,
                  itemBuilder: (context, i) =>
                      _TaskCard(task: details.tasks[i]),
                ),
        ),
      ],
    );
  }
}

class _StatsBox extends StatelessWidget {
  const _StatsBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s8,
        horizontal: AppWidth.s6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s10),
      ),
      child: Column(
        children: [
          SizedBox(height: AppHeight.s4),
          Text(
            value,
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: color,
            ),
          ),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.blueOne100,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final VolunteerTaskAssignmentEntity task;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'completed';
    final statusColor = isCompleted
        ? const Color(0xFF22C55E)
        : const Color(0xFF60A5FA);
    final statusBg = isCompleted
        ? const Color(0xFF14532D)
        : const Color(0xFF1E3A5F);
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
              color: const Color(0xFF1F2E4F),
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
