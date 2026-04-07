import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaigns_cubit.dart';
import 'widgets/campaign_stat_box.dart';
import 'widgets/campaign_filter_chips.dart';
import 'widgets/campaign_list_card.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CampaignsView extends StatefulWidget {
  const CampaignsView({super.key});

  @override
  State<CampaignsView> createState() => _CampaignsViewState();
}

class _CampaignsViewState extends State<CampaignsView> {
  final GlobalKey _filterChipsKey = GlobalKey();
  final GlobalKey _firstCampaignCardKey = GlobalKey();
  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;

  @override
  void initState() {
    super.initState();
    _tutorialListener = () => _checkTutorial();
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CampaignsCubit>().load();
    });
  }

  @override
  void dispose() {
    TutorialPhaseService.instance.phaseNotifier.removeListener(
      _tutorialListener,
    );
    super.dispose();
  }

  void _checkTutorial() {
    if (!mounted) return;
    final svc = TutorialPhaseService.instance;
    if (!svc.isRunning) return;
    if (svc.currentPhase != 3 || !svc.isAdmin) return;
    if (_lastCheckedPhase == 3) return; // Already showed phase 3

    debugPrint('📘 TUTORIAL: Campaigns screen starting phase 3, marking _lastCheckedPhase=3');
    _lastCheckedPhase = 3; // Mark immediately since campaigns list renders synchronously
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showCampaignsTutorial();
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
              color: ColorManager.natural900,
            ),
          ),
          centerTitle: true,
          leadingWidth: AppWidth.s125,
          leading: Center(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: AppWidth.s18),
              child: GestureDetector(
                onTap: () async {
                  final refreshed = await context.push<bool>('/createCampaign');
                  if (refreshed == true && context.mounted) {
                    context.read<CampaignsCubit>().load();
                  }
                },
                child: Container(
                  height: AppHeight.s26,
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s12),
                  decoration: BoxDecoration(
                    color: ColorManager.primary50,
                    borderRadius: BorderRadius.circular(AppRadius.s20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(IconAssets.add),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        'حملة جديدة',
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s12,
                          color: ColorManager.primary500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<CampaignsCubit, CampaignsState>(
          listener: (context, state) {
            if (state is CampaignsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _checkTutorial(),
              );
            }
          },
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
              onRefresh: () async {
                HapticFeedback.mediumImpact();
                try {
                  await cubit.load(skipCache: true);
                  HapticFeedback.lightImpact();
                } catch (e) {
                  HapticFeedback.heavyImpact();
                }
              },
              color: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFF00ABD2),
              displacement: 40.0,
              strokeWidth: 2.5,
              semanticsLabel: 'تحديث الحملات',
              semanticsValue: '0%',
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppWidth.s18,
                        AppHeight.s24,
                        AppWidth.s18,
                        AppHeight.s18,
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppHeight.s12),
                      child: CampaignFilterChips(
                        key: _filterChipsKey,
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
                  state.campaigns.isEmpty
                      ? const SliverFillRemaining(
                          child: EmptyStateText(message: 'لا توجد حملات'),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppWidth.s18,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final campaign = state.campaigns[i];
                              return CampaignListCard(
                                key: i == 0 ? _firstCampaignCardKey : null,
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

  void _showCampaignsTutorial() {
    final hasCard = _firstCampaignCardKey.currentContext != null;
    final total = hasCard ? 2 : 1;
    final targets = <TargetFocus>[];

    if (_filterChipsKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'campaign_filter',
          keyTarget: _filterChipsKey,
          title: 'تصفية الحملات',
          description: 'فلتر حسب الحالة: قادمة، جارية، مكتملة',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: total,
        ),
      );
    }

    if (hasCard) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'campaign_card',
          keyTarget: _firstCampaignCardKey,
          title: 'بطاقة الحملة',
          description: 'اضغط على أي حملة لعرض تفاصيلها وإدارة فريقها',
          contentAlign: ContentAlign.bottom,
          stepIndex: 2,
          totalSteps: total,
        ),
      );
    }

    if (targets.isEmpty) {
      debugPrint(
        '📘 TUTORIAL: AdminCampaigns screen has no targets, advancing to next phase',
      );
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      textSkip: "تخطي",
      paddingFocus: 10,
      focusAnimationDuration: const Duration(milliseconds: 300),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 600),
      textStyleSkip: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FontConstants.fontFamily),
      onFinish: () => TutorialPhaseService.instance.advanceToNextPhase(),
      onSkip: () {
        TutorialPhaseService.instance.advanceToNextPhase(); // Continue chain, don't kill it
        return true;
      },
    ).show(context: context, rootOverlay: true);
  }
}
