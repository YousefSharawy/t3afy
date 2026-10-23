import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/primary_tab_bar.dart';
import 'widgets/actions_tab.dart';
import 'widgets/campaign_hero_card.dart';
import 'widgets/live_map_tab.dart';
import 'widgets/overview_tab.dart';
import 'widgets/team_tab.dart';

class CampaignDetailView extends StatefulWidget {
  const CampaignDetailView({super.key, required this.taskId});

  final String taskId;

  @override
  State<CampaignDetailView> createState() => _CampaignDetailViewState();
}

class _CampaignDetailViewState extends State<CampaignDetailView>
    with SingleTickerProviderStateMixin {
  static const _mapTab = 3;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<CampaignDetailCubit>().load(widget.taskId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CampaignDetailCubit>();
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'تفاصيل الحملة',
              showBack: true,
              // Only ask the list to reload when something actually changed.
              onBack: () => context.pop(cubit.hasChanges),
            ),
            Expanded(
              child: BlocConsumer<CampaignDetailCubit, CampaignDetailState>(
                listener: (context, state) {
                  if (state is CampaignDetailDeleted) {
                    Toast.success.show(context, title: 'تم حذف الحملة بنجاح');
                    context.pop(true);
                  } else if (state is CampaignDetailActionError) {
                    Toast.error.show(context, title: state.message);
                  } else if (state is CampaignDetailAlertSent) {
                    Toast.success.show(context, title: 'تم إرسال التنبيه بنجاح');
                  }
                },
                buildWhen: (previous, current) =>
                    current is CampaignDetailLoaded ||
                    current is CampaignDetailLoading ||
                    current is CampaignDetailError,
                builder: (context, state) {
                  final detail = cubit.detail;
                  return AppAsyncBody(
                    hasData: detail != null,
                    errorMessage: state is CampaignDetailError
                        ? state.message
                        : null,
                    onRetry: () => cubit.load(widget.taskId),
                    skeleton: const _DetailSkeleton(),
                    builder: (context) => Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Space.gutter,
                          ),
                          child: CampaignHeroCard(detail: detail!),
                        ),
                        SizedBox(height: Space.vl),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Space.gutter,
                          ),
                          child: PrimaryTabBar(
                            controller: _tabController,
                            labels: const [
                              'نظرة عامة',
                              'الفريق',
                              'الإجراءات',
                              'الخريطة',
                            ],
                          ),
                        ),
                        Expanded(
                          // The map handles its own pan gestures, so swiping
                          // between tabs is turned off while it is shown.
                          child: ListenableBuilder(
                            listenable: _tabController,
                            builder: (context, _) => TabBarView(
                              controller: _tabController,
                              physics: _tabController.index == _mapTab
                                  ? const NeverScrollableScrollPhysics()
                                  : null,
                              children: [
                                OverviewTab(detail: detail),
                                TeamTab(detail: detail),
                                ActionsTab(detail: detail),
                                LiveMapTab(detail: detail),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Space.gutter),
      children: [
        Skeleton(
          child: Column(
            children: [
              SkeletonBox(height: 132, radius: Radii.card),
              SizedBox(height: Space.vl),
              SkeletonBox(height: 44, radius: Radii.input),
            ],
          ),
        ),
        SkeletonList(
          count: 3,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: Space.vl),
        ),
      ],
    );
  }
}
