import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/primary_tab_bar.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'widgets/campaign_hero_card.dart';
import 'widgets/overview_tab.dart';
import 'widgets/team_tab.dart';
import 'widgets/actions_tab.dart';
import 'widgets/live_map_tab.dart';

class CampaignDetailView extends StatefulWidget {
  const CampaignDetailView({super.key, required this.taskId});

  final String taskId;

  @override
  State<CampaignDetailView> createState() => _CampaignDetailViewState();
}

class _CampaignDetailViewState extends State<CampaignDetailView>
    with SingleTickerProviderStateMixin {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
            backgroundColor: ColorManager.background,
        appBar: AppBar(
            backgroundColor: ColorManager.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.natural900,
              size: 24.sp,
            ),
            onPressed: () => context.pop(true),
          ),
          title: Text(
            'تفاصيل الحملة',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.natural900,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<CampaignDetailCubit, CampaignDetailState>(
          listener: (context, state) {
            if (state is CampaignDetailDeleted) {
              Toast.success.show(context, title: 'تم حذف الحملة بنجاح');
              if (context.mounted) context.pop(true);
            } else if (state is CampaignDetailActionError) {
              Toast.error.show(context, title: state.message);
            } else if (state is CampaignDetailAlertSent) {
              Toast.success.show(context, title: 'تم إرسال التنبيه بنجاح');
            }
          },
          buildWhen: (previous, current) =>
              current is! CampaignDetailSaving &&
              current is! CampaignDetailDeleted &&
              current is! CampaignDetailAlertSent &&
              current is! CampaignDetailActionError,
          builder: (context, state) {
            if (state is CampaignDetailLoading || state is CampaignDetailInitial) {
              return const LoadingIndicator();
            }
            if (state is CampaignDetailError) {
              return ErrorState(
                message: state.message,
                onRetry: () =>
                    context.read<CampaignDetailCubit>().load(widget.taskId),
              );
            }

            final detail = state is CampaignDetailLoaded
                ? state.detail
                : null;
            if (detail == null) return const LoadingIndicator();

            return Column(
              children: [
                SizedBox(height: AppHeight.s16),
                CampaignHeroCard(detail: detail),
                SizedBox(height: AppHeight.s16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  child: PrimaryTabBar(
                    controller: _tabController,
                    labels: const ['نظرة عامة', 'الفريق', 'الاجراءات', 'الخريطة'],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      OverviewTab(detail: detail),
                      TeamTab(detail: detail),
                      ActionsTab(detail: detail),
                      LiveMapTab(detail: detail),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
