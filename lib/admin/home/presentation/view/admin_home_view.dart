import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/admin_app_bar.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/quick_actions_section.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/send_announcement_sheet.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/stats_grid.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/status_banner.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/monthly_chart.dart';
import 'package:t3afy/admin/home/presentation/view/widgets/today_campaigns_section.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  void _showAnnouncementSheet(BuildContext context) {
    final cubit = context.read<AdminHomeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const SendAnnouncementSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: BlocBuilder<AdminHomeCubit, AdminHomeState>(
        buildWhen: (prev, curr) => curr.maybeWhen(
          initial: () => true,
          loading: () => true,
          loaded: (_) => true,
          error: (_) => true,
          orElse: () => false,
        ),
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const LoadingIndicator(),
            error: (message) => ErrorState(
              message: message,
              onRetry: () => context.read<AdminHomeCubit>().loadDashboard(),
            ),
            loaded: (data) => Directionality(
              textDirection: TextDirection.rtl,
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<AdminHomeCubit>().loadDashboard(),
                color: const Color(0xFF00ABD2),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppHeight.s71),
                        AdminAppBar(
                          adminName: data.adminName,
                          avatarUrl: data.adminAvatar,
                        ),
                        StatusBanner(
                          activeVolunteersCount: data.activeTodayCount,
                        ),
                        SizedBox(height: AppHeight.s16),
                        StatsGrid(
                          activeTodayCount: data.activeTodayCount,
                          totalVolunteers: data.totalVolunteers,
                          completedCampaigns: data.completedCampaigns,
                          totalHours: data.totalHours,
                          volunteersThisMonth: data.volunteersThisMonth,
                          activeDiffFromYesterday: data.activeDiffFromYesterday,
                          hoursPercentChange: data.hoursPercentChange,
                        ),
                        SizedBox(height: AppHeight.s24),
                        MonthlyChartWidget(data: data.monthlyCompletedTasks),
                        SizedBox(height: AppHeight.s16),
                        QuickActionsSection(
                          onNewCampaign: () {},
                          onFullReport: () {},
                          onSendAnnouncement: () =>
                              _showAnnouncementSheet(context),
                        ),
                        SizedBox(height: AppHeight.s16),
                        TodayCampaignsSection(
                          campaigns: data.todayCampaigns,
                          onViewAll: () => context.go(Routes.campaigns),
                          onCampaignTap: (campaign) =>
                              context.push('/campaignDetails/${campaign.id}'),
                        ),
                        SizedBox(height: AppHeight.s100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
