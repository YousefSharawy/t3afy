import 'package:flutter/material.dart';
import 'package:t3afy/admin/home/domain/entities/admin_home_data_entity.dart'
    show MonthlyTaskCount;
import 'package:t3afy/admin/home/presentation/view/widgets/monthly_chart.dart';

class PerformanceBarChart extends StatelessWidget {
  const PerformanceBarChart({super.key, required this.data});

  final List<MonthlyTaskCount> data;

  @override
  Widget build(BuildContext context) {
    return MonthlyChartWidget(data: data);
  }
}
