import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaigns_cubit.dart';
import 'widgets/campaign_stat_box.dart';
import 'widgets/campaign_filter_chips.dart';
import 'widgets/campaign_list_card.dart';

class CampaignsView extends StatefulWidget {
  const CampaignsView({super.key});

  @override
  State<CampaignsView> createState() => _CampaignsViewState();
}

class _CampaignsViewState extends State<CampaignsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CampaignsCubit>().load();
    });
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
          title: Text(
            'إدارة الحملات',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.blueOne900,
            ),
          ),
          centerTitle: true,
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: AppWidth.s18),
                child: GestureDetector(
                  onTap: () async {
                    final refreshed = await context.push<bool>(
                      '/createCampaign',
                    );
                    if (refreshed == true && context.mounted) {
                      context.read<CampaignsCubit>().load();
                    }
                  },
                  child: Container(
                    height: AppHeight.s26,
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.s15),
                    decoration: BoxDecoration(
                      color: ColorManager.blueOne900,
                      borderRadius: BorderRadius.circular(AppRadius.s6),
                    ),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Image.asset(IconAssets.add),
                        SizedBox(width: AppWidth.s4),
                        Text(
                          'حملة جديدة',
                          style: getBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s12,
                            color: ColorManager.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<CampaignsCubit, CampaignsState>(
          builder: (context, state) {
            if (state is CampaignsLoading || state is CampaignsInitial) {
              return const LoadingIndicator();
            }
            if (state is CampaignsError) {
              return ErrorState(
                message: state.message,
                onRetry: () => context.read<CampaignsCubit>().load(),
              );
            }
            if (state is! CampaignsLoaded) return const SizedBox.shrink();

            final cubit = context.read<CampaignsCubit>();
            return RefreshIndicator(
              onRefresh: () => cubit.load(),
              color: const Color(0xFF00ABD2),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppWidth.s16,
                        AppHeight.s12,
                        AppWidth.s16,
                        AppHeight.s16,
                      ),
                      child: Row(
                        children: [
                          CampaignStatBox(
                            label: 'اشعار',
                            value: '${state.stats['notifications'] ?? 0}',
                          ),
                          SizedBox(width: AppWidth.s8),
                          CampaignStatBox(
                            label: 'قادمة',
                            value: '${state.stats['upcoming'] ?? 0}',
                          ),
                          SizedBox(width: AppWidth.s8),
                          CampaignStatBox(
                            label: 'مكتملة',
                            value: '${state.stats['done'] ?? 0}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Filter chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
                      child: CampaignFilterChips(
                        selected: state.filter,
                        onSelect: cubit.setFilter,
                        counts: {
                          'all':
                              (state.stats['active'] ?? 0) +
                              (state.stats['upcoming'] ?? 0) +
                              (state.stats['done'] ?? 0),
                          'active': state.stats['active'] ?? 0,
                          'upcoming': state.stats['upcoming'] ?? 0,
                          'done': state.stats['done'] ?? 0,
                        },
                      ),
                    ),
                  ),
                  // Campaign list
                  state.campaigns.isEmpty
                      ? const SliverFillRemaining(
                          child: EmptyStateText(message: 'لا توجد حملات'),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppWidth.s16,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final campaign = state.campaigns[i];
                              return CampaignListCard(
                                campaign: campaign,
                                onTap: () async {
                                  final refreshed = await context.push<bool>(
                                    '/campaignDetails/${campaign.id}',
                                  );
                                  if (refreshed == true && context.mounted) {
                                    cubit.load();
                                  }
                                },
                              );
                            }, childCount: state.campaigns.length),
                          ),
                        ),
                  SliverToBoxAdapter(child: SizedBox(height: AppHeight.s80)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
