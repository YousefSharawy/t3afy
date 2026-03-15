import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaign_detail_cubit.dart';
import 'widgets/campaign_hero_card.dart';
import 'widgets/overview_tab.dart';
import 'widgets/team_tab.dart';
import 'widgets/actions_tab.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
        backgroundColor: ColorManager.blueOne900,
        appBar: AppBar(
          backgroundColor: ColorManager.blueOne900,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.r,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'تفاصيل الحملة',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<CampaignDetailCubit, CampaignDetailState>(
          listener: (context, state) {
            if (state is CampaignDetailActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is CampaignDetailAlertSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم إرسال التنبيه بنجاح'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            }
          },
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
            if (state is CampaignDetailSaving) {
              return const LoadingIndicator();
            }

            final detail = state is CampaignDetailLoaded
                ? state.detail
                : null;
            if (detail == null) return const LoadingIndicator();

            return Column(
              children: [
                SizedBox(height: AppHeight.s8),
                CampaignHeroCard(detail: detail),
                SizedBox(height: AppHeight.s16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne800,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    border: Border.all(color: ColorManager.blueOne700),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF00ABD2),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: const Color(0xFF00ABD2),
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
                    dividerColor: Colors.transparent,
                    labelStyle: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s12,
                    ),
                    tabs: const [
                      Tab(text: 'نظرة عامة'),
                      Tab(text: 'الفريق'),
                      Tab(text: 'الاجراءات'),
                    ],
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      OverviewTab(detail: detail),
                      TeamTab(detail: detail),
                      ActionsTab(detail: detail),
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
