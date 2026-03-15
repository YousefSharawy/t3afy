import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.activeTodayCount,
    required this.totalVolunteers,
    required this.completedCampaigns,
    required this.totalHours,
  });

  final int activeTodayCount;
  final int totalVolunteers;
  final int completedCampaigns;
  final double totalHours;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.directions_run_rounded,
                  iconColor: Colors.amber,
                  value: '$activeTodayCount',
                  label: 'نشيط اليوم',
                  trend: '↑1 عن أمس',
                ),
              ),
              SizedBox(width: AppWidth.s12),
              Expanded(
                child: StatCard(
                  icon: Icons.groups_rounded,
                  iconColor: Colors.blue,
                  value: '$totalVolunteers',
                  label: 'اجمالي المتطوعين',
                  trend: '↑12 هذا الشهر',
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                  value: '$completedCampaigns',
                  label: 'حملة مكتملة',
                ),
              ),
              SizedBox(width: AppWidth.s12),
              Expanded(
                child: StatCard(
                  icon: Icons.schedule_rounded,
                  iconColor: Colors.blue,
                  value: totalHours.toStringAsFixed(0),
                  label: 'ساعات التطوع',
                  trend: '↑23% هذا الشهر',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
