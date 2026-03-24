import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'package:t3afy/volunteer/performance/presentation/cubit/performance_cubit.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/honor_board.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/monthly_chart.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/performance_stats_row.dart';
import 'package:t3afy/volunteer/performance/presentation/view/widgets/rating_card.dart';

class VolunteerPerformanceView extends StatefulWidget {
  const VolunteerPerformanceView({super.key});

  @override
  State<VolunteerPerformanceView> createState() =>
      _VolunteerPerformanceViewState();
}

class _VolunteerPerformanceViewState extends State<VolunteerPerformanceView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PerformanceCubit>();
    if (!cubit.state.maybeWhen(loaded: (a, b, c, d) => true, orElse: () => false)) {
      final userId = LocalAppStorage.getUserId();
      if (userId != null) {
        cubit.loadPerformance(userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PerformanceCubit, PerformanceState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LoadingIndicator(),
            error: (message) => ErrorState(
              message: message,
              onRetry: () {
                final userId = LocalAppStorage.getUserId();
                if (userId != null) {
                  context.read<PerformanceCubit>().loadPerformance(userId);
                }
              },
            ),
            loaded: (stats, monthlyHours, leaderboard, currentUserId) =>
                _buildContent(stats, monthlyHours, leaderboard, currentUserId),
          );
        },
      ),
    );
  }

  Future<void> _refresh() {
    final userId = LocalAppStorage.getUserId();
    if (userId != null) {
      return context.read<PerformanceCubit>().loadPerformance(userId);
    }
    return Future.value();
  }

  Widget _buildContent(
    PerformanceStatsEntity stats,
    List<MonthlyHoursEntity> monthlyHours,
    List<LeaderboardEntryEntity> leaderboard,
    String currentUserId,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppHeight.s10),
          child: Text(
            'الاداء و التقييم',
            style: getExtraBoldStyle(
              fontFamily: FontConstants.fontFamily,
              color: ColorManager.natural900,
              fontSize: FontSize.s16,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: const Color(0xFF00ABD2),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: AppWidth.s18,
                right: AppWidth.s18,
                top: AppHeight.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingCard(stats: stats),
                  SizedBox(height: AppHeight.s16),
                  PerformanceStatsRow(stats: stats),
                  SizedBox(height: AppHeight.s12),
                  MonthlyChart(monthlyHours: monthlyHours),
                  SizedBox(height: AppHeight.s16),
                  HonorBoard(
                    leaderboard: leaderboard,
                    currentUserId: currentUserId,
                  ),
                  SizedBox(height: AppHeight.s100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}