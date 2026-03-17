import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
            backgroundColor: ColorManager.background,
        appBar: AppBar(
            backgroundColor: ColorManager.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.blueOne900,
              size: 20.r,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'تفاصيل الحملة',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.blueOne900,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<CampaignDetailCubit, CampaignDetailState>(
          listener: (context, state) {
            if (state is CampaignDetailDeleted) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الحملة بنجاح'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
              if (context.mounted) context.go('/campaigns');
            } else if (state is CampaignDetailActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is CampaignDetailAlertSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال التنبيه بنجاح'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
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
                SizedBox(height: AppHeight.s8),
                CampaignHeroCard(detail: detail),
                SizedBox(height: AppHeight.s16),
                Container(
                  padding: EdgeInsets.all(4.sp),
                  margin: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne800,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      
                      color: const Color(0xFF703DEB),
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
                    dividerColor: Colors.transparent,
                    padding: EdgeInsets.all(AppSize.s4),
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
