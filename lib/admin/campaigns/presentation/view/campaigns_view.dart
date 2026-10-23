import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/campaigns/domain/entities/campaign_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/campaigns_cubit.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/filter_chip_item.dart';
import 'package:t3afy/base/widgets/stat_tile.dart';
import 'package:t3afy/base/widgets/task_campaign_card.dart';
import 'package:t3afy/core/utils/date_ar.dart';
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

  static const _chips = [
    ('all', 'الكل'),
    ('active', 'جارية'),
    ('upcoming', 'قادمة'),
    ('done', 'مكتملة'),
    ('missed', 'فائتة'),
  ];

  @override
  void initState() {
    super.initState();
    // The cubit loads itself on creation; no second load here.
    _tutorialListener = _checkTutorial;
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);
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
    if (_lastCheckedPhase == 3) return;
    _lastCheckedPhase = 3;
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showCampaignsTutorial();
    });
  }

  Future<void> _openCreate() async {
    final cubit = context.read<CampaignsCubit>();
    final created = await context.push<bool>('/createCampaign');
    if (created == true) cubit.load(skipCache: true);
  }

  Future<void> _openDetail(CampaignEntity campaign) async {
    final cubit = context.read<CampaignsCubit>();
    final changed = await context.push<bool>('/campaignDetails/${campaign.id}');
    if (changed == true) cubit.load(skipCache: true);
  }

  Future<void> _refresh() async {
    final error = await context.read<CampaignsCubit>().refresh();
    if (error != null && mounted) Toast.error.show(context, title: error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'إدارة الحملات',
              reserveBellSpace: true,
              actions: [_NewCampaignButton(onPressed: _openCreate)],
            ),
            Expanded(
              child: BlocConsumer<CampaignsCubit, CampaignsState>(
                listenWhen: (prev, curr) =>
                    curr is CampaignsLoaded && prev is! CampaignsLoaded,
                listener: (context, state) => WidgetsBinding.instance
                    .addPostFrameCallback((_) => _checkTutorial()),
                builder: (context, state) {
                  final loaded = state is CampaignsLoaded ? state : null;
                  return AppAsyncBody(
                    hasData: loaded != null,
                    errorMessage: state is CampaignsError ? state.message : null,
                    onRetry: () => context.read<CampaignsCubit>().load(),
                    skeleton: const _CampaignsSkeleton(),
                    builder: (context) => _buildLoaded(context, loaded!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, CampaignsLoaded state) {
    final cubit = context.read<CampaignsCubit>();
    final counts = state.stats;
    final total = counts['all'] ?? 0;

    return RefreshIndicator(
      onRefresh: _refresh,
      color: ColorManager.brand,
      backgroundColor: ColorManager.surface,
      semanticsLabel: 'تحديث الحملات',
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Space.gutter),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: StatTile(
                      value: '${counts['active'] ?? 0}',
                      label: 'جارية',
                      icon: AppIcons.campaigns,
                    ),
                  ),
                  SizedBox(width: Space.s),
                  Expanded(
                    child: StatTile(
                      value: '${counts['upcoming'] ?? 0}',
                      label: 'قادمة',
                      icon: AppIcons.calendar,
                      tint: ColorManager.warning,
                    ),
                  ),
                  SizedBox(width: Space.s),
                  Expanded(
                    child: StatTile(
                      value: '${counts['done'] ?? 0}',
                      label: 'مكتملة',
                      icon: AppIcons.done,
                      tint: ColorManager.sprout,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (total == 0)
            SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                title: 'لا توجد حملات بعد',
                message: 'أنشئ أول حملة وعيّن فريقها',
                icon: AppIcons.campaigns,
                actionLabel: 'حملة جديدة',
                onAction: _openCreate,
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: SizedBox(
                key: _filterChipsKey,
                height: AppSizes.touch,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: Space.gutter,
                    vertical: Space.xs,
                  ),
                  itemCount: _chips.length,
                  separatorBuilder: (_, _) => SizedBox(width: Space.s),
                  itemBuilder: (context, i) {
                    final (value, label) = _chips[i];
                    return Center(
                      child: FilterChipItem(
                        label: label,
                        count: counts[value] ?? 0,
                        selected: state.filter == value,
                        onTap: () => cubit.setFilter(value),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: Space.vs)),
            if (state.campaigns.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: AppEmptyState(
                  title: 'لا توجد حملات بهذه الحالة',
                  icon: AppIcons.campaigns,
                  compact: true,
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: Space.gutter),
                sliver: SliverList.separated(
                  itemCount: state.campaigns.length,
                  separatorBuilder: (_, _) => SizedBox(height: Space.vm),
                  itemBuilder: (context, i) {
                    final c = state.campaigns[i];
                    return KeyedSubtree(
                      key: ValueKey(c.id),
                      child: _CampaignTile(
                        key: i == 0 ? _firstCampaignCardKey : null,
                        campaign: c,
                        onTap: () => _openDetail(c),
                      ),
                    );
                  },
                ),
              ),
          ],
          SliverToBoxAdapter(
            child: SizedBox(
              height: Space.vl + AppNavShell.bottomInset(context),
            ),
          ),
        ],
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
      TutorialPhaseService.instance.advanceToNextPhase();
      return;
    }

    TutorialService.buildPhaseContinuing(
      targets: targets,
      onFinish: TutorialPhaseService.instance.advanceToNextPhase,
    ).show(context: context, rootOverlay: true);
  }
}

class _CampaignTile extends StatelessWidget {
  const _CampaignTile({super.key, required this.campaign, required this.onTap});

  final CampaignEntity campaign;
  final VoidCallback onTap;

  /// Attendance only means something once the campaign has started.
  bool get _showsAttendance => const {
    'active',
    'ongoing',
    'in_progress',
    'completed',
    'done',
    'missed',
  }.contains(campaign.status);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(campaign.date);
    final showBar = _showsAttendance && campaign.volunteerCount > 0;
    return TaskCampaignCard(
      title: campaign.title,
      status: campaign.status,
      typeLabel: campaign.type,
      time: DateAr.timeRange(campaign.timeStart, campaign.timeEnd),
      date: date == null ? campaign.date : DateAr.date(date),
      location: campaign.locationName,
      teamFilled: showBar ? campaign.attendedCount : null,
      teamTotal: showBar ? campaign.volunteerCount : null,
      trailing: MetaItem(
        icon: AppIcons.group,
        text: campaign.volunteerCount == 0
            ? 'لا يوجد فريق بعد'
            : '${campaign.volunteerCount} متطوع',
      ),
      onTap: onTap,
    );
  }
}

class _NewCampaignButton extends StatelessWidget {
  const _NewCampaignButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(AppIcons.add, size: 18),
      label: Text(
        'حملة جديدة',
        style: getSemiBoldStyle(
          fontSize: FontSize.s13,
          color: ColorManager.white,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: ColorManager.brand,
        foregroundColor: ColorManager.white,
        minimumSize: Size(0, AppSizes.touch * 0.8),
        padding: EdgeInsets.symmetric(horizontal: Space.m),
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _CampaignsSkeleton extends StatelessWidget {
  const _CampaignsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Space.gutter),
      children: [
        Skeleton(
          child: Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) SizedBox(width: Space.s),
                Expanded(
                  child: SkeletonBox(height: 96, radius: Radii.card),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: Space.vl),
        Skeleton(
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                SkeletonBox(width: 64, height: 32, radius: Radii.chip),
                SizedBox(width: Space.s),
              ],
            ],
          ),
        ),
        SkeletonList(
          count: 4,
          itemHeight: 132,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: Space.vl),
        ),
      ],
    );
  }
}
