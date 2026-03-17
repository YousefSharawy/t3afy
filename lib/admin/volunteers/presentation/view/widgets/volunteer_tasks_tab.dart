import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'volunteer_stats_box.dart';
import 'volunteer_task_card.dart';

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
                child: VolunteerStatsBox(
                  label: 'منجزة',
                  value: '${details.completedTasksCount}',
                  color: const Color(0xFF22C55E),
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: VolunteerStatsBox(
                  label: 'ساعة',
                  value: '${details.totalHours}',
                  color: const Color(0xFF60A5FA),
                ),
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: VolunteerStatsBox(
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
                      VolunteerTaskCard(task: details.tasks[i]),
                ),
        ),
      ],
    );
  }
}
