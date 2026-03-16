import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_cubit.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/campaign_completion_card.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/performance_bar_chart.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/performance_stats_row.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/performance_time_filter.dart';
import 'package:t3afy/admin/performance/presentation/view/widgets/region_ranking_section.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';

class AdminPerformanceView extends StatelessWidget {
  const AdminPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'التقارير والاحصاء',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.blueOne900,
            ),
          ),
        ),
        body: BlocBuilder<AdminPerformanceCubit, AdminPerformanceState>(
          builder: (context, state) {
            if (state is AdminPerformanceLoading ||
                state is AdminPerformanceInitial) {
              return const LoadingIndicator();
            }
            if (state is AdminPerformanceError) {
              return ErrorState(
                message: state.message,
                onRetry: () =>
                    context.read<AdminPerformanceCubit>().loadPerformance(),
              );
            }
            if (state is! AdminPerformanceLoaded) {
              return const SizedBox.shrink();
            }
            final data = state.data;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppHeight.s24),
                  const PerformanceTimeFilter(),
                  SizedBox(height: AppHeight.s16),
                  PerformanceStatsRow(data: data),
                  SizedBox(height: AppHeight.s8),
                  PerformanceBarChart(data: data.monthlyCompletedTasks),
                  SizedBox(height: AppHeight.s8),
                  RegionRankingSection(regions: data.topRegions),
                  SizedBox(height: AppHeight.s8),
                  CampaignCompletionCard(data: data),
                  SizedBox(height: AppHeight.s100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
