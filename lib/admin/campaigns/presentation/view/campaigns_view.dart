import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaigns_cubit.dart';
import 'widgets/campaign_stat_box.dart';
import 'widgets/campaign_filter_chips.dart';
import 'widgets/campaign_list_card.dart';

class CampaignsView extends StatelessWidget {
  const CampaignsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.blueOne900,
        appBar: AppBar(
          backgroundColor: ColorManager.blueOne900,
          elevation: 0,
          title: Text(
            'إدارة الحملات',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(left: AppWidth.s12),
              child: GestureDetector(
                onTap: () async {
                  final refreshed = await context.push<bool>('/createCampaign');
                  if (refreshed == true && context.mounted) {
                    context.read<CampaignsCubit>().load();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s12,
                    vertical: AppHeight.s6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00ABD2),
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                  ),
                  child: Text(
                    'حملة جديدة +',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s12,
                      color: Colors.white,
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
                  // Stats row
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppWidth.s16,
                        AppHeight.s12,
                        AppWidth.s16,
                        AppHeight.s4,
                      ),
                      child: Row(
                        children: [
                          CampaignStatBox(
                            label: 'اشعار',
                            value: '${state.stats['notifications'] ?? 0}',
                            icon: Icons.notifications_outlined,
                            color: const Color(0xFF0EA5E9),
                          ),
                          SizedBox(width: AppWidth.s8),
                          CampaignStatBox(
                            label: 'قادمة',
                            value: '${state.stats['upcoming'] ?? 0}',
                            icon: Icons.upcoming_outlined,
                            color: const Color(0xFFA78BFA),
                          ),
                          SizedBox(width: AppWidth.s8),
                          CampaignStatBox(
                            label: 'مكتملة',
                            value: '${state.stats['done'] ?? 0}',
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF4ADE80),
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
                      ),
                    ),
                  ),
                  // Campaign list
                  state.campaigns.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'لا توجد حملات',
                              style: getMediumStyle(
                                fontFamily: FontConstants.fontFamily,
                                fontSize: FontSize.s14,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppWidth.s16,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final campaign = state.campaigns[i];
                                return CampaignListCard(
                                  campaign: campaign,
                                  onTap: () async {
                                    final refreshed = await context
                                        .push<bool>('/campaignDetails/${campaign.id}');
                                    if (refreshed == true && context.mounted) {
                                      cubit.load();
                                    }
                                  },
                                );
                              },
                              childCount: state.campaigns.length,
                            ),
                          ),
                        ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppHeight.s80),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
