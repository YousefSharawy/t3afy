import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_cubit.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/base/widgets/app_segmented_tabs.dart';

/// Rolling windows: last 7 days / last 30 days / last 12 months.
class PerformanceTimeFilter extends StatelessWidget {
  const PerformanceTimeFilter({super.key});

  static const _labels = ['أسبوع', 'شهر', 'سنة'];
  static const _periods = ['week', 'months', 'year'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminPerformanceCubit, AdminPerformanceState>(
      builder: (context, _) {
        final cubit = context.read<AdminPerformanceCubit>();
        final index = _periods.indexOf(cubit.currentPeriod);
        return AppSegmentedTabs(
          labels: _labels,
          selectedIndex: index < 0 ? 2 : index,
          onChanged: (i) async {
            if (_periods[i] == cubit.currentPeriod) return;
            final error = await cubit.loadPerformance(_periods[i]);
            if (error != null && context.mounted) {
              Toast.error.show(context, title: error);
            }
          },
        );
      },
    );
  }
}
