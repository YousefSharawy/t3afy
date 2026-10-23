import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/add_volunteer_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_card.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_filter_chips.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_search_bar.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VolunteersPanelView extends StatefulWidget {
  const VolunteersPanelView({super.key});

  @override
  State<VolunteersPanelView> createState() => _VolunteersPanelViewState();
}

class _VolunteersPanelViewState extends State<VolunteersPanelView> {
  final GlobalKey _searchBarKey = GlobalKey();
  final GlobalKey _filterChipsKey = GlobalKey();
  final GlobalKey _firstCardKey = GlobalKey();

  late final VoidCallback _tutorialListener;
  int _lastCheckedPhase = 0;

  @override
  void initState() {
    super.initState();
    _tutorialListener = () => _checkTutorial();
    TutorialPhaseService.instance.phaseNotifier.addListener(_tutorialListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTutorial());
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
    if (svc.currentPhase != 2 || !svc.isAdmin) return;
    if (_lastCheckedPhase == 2) return; // Already showed phase 2

    _lastCheckedPhase = 2; // Mark immediately since volunteers list renders synchronously
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showVolunteersTutorial();
    });
  }

  void _openAddSheet() {
    HapticFeedback.mediumImpact();
    final cubit = context.read<VolunteersCubit>();
    showVolunteerSheet<void>(
      context,
      BlocProvider.value(value: cubit, child: const AddVolunteerSheet()),
    );
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
              title: 'إدارة المتطوعين',
              reserveBellSpace: true,
              actions: [_AddVolunteerAction(onPressed: _openAddSheet)],
            ),
            Expanded(
              child: BlocConsumer<VolunteersCubit, VolunteersState>(
                listenWhen: (p, c) =>
                    c.maybeWhen(loaded: (_, _, _, _, _) => true, orElse: () => false) &&
                    !p.maybeWhen(loaded: (_, _, _, _, _) => true, orElse: () => false),
                listener: (context, state) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _checkTutorial(),
                  );
                },
                builder: (context, state) {
                  return state.when(
                    initial: () => const _PanelSkeleton(),
                    loading: () => const _PanelSkeleton(),
                    error: (message) => ErrorState(
                      message: message,
                      onRetry: () =>
                          context.read<VolunteersCubit>().loadVolunteers(),
                    ),
                    loaded:
                        (volunteers, filter, searchQuery, pendingUsers, _) =>
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Space.gutter,
                                  ),
                                  child: VolunteerSearchBar(key: _searchBarKey),
                                ),
                                SizedBox(height: Space.vm),
                                // Re-renders once a minute so "online" badges
                                // and the status counts age out on their own.
                                Expanded(
                                  child: _MinuteTicker(
                                    builder: (context) => _LoadedBody(
                                      volunteers: volunteers,
                                      filter: filter,
                                      searchQuery: searchQuery,
                                      filterChipsKey: _filterChipsKey,
                                      firstCardKey: _firstCardKey,
                                      onAdd: _openAddSheet,
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

  void _showVolunteersTutorial() {
    final hasCard = _firstCardKey.currentContext != null;
    final total = hasCard ? 3 : 2;
    final targets = <TargetFocus>[];

    if (_searchBarKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'vol_search',
          keyTarget: _searchBarKey,
          title: 'البحث',
          description: 'ابحث عن متطوع بالاسم',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: total,
        ),
      );
    }

    if (_filterChipsKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'vol_filter_chips',
          keyTarget: _filterChipsKey,
          title: 'تصفية المتطوعين',
          description: 'فلتر المتطوعين حسب الحالة: الكل، نشط، قيد المراجعة',
          contentAlign: ContentAlign.bottom,
          stepIndex: 2,
          totalSteps: total,
        ),
      );
    }

    if (hasCard) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'vol_card',
          keyTarget: _firstCardKey,
          title: 'بطاقة المتطوع',
          description: 'اضغط على أي متطوع لعرض تفاصيله وإدارة بياناته',
          contentAlign: ContentAlign.bottom,
          stepIndex: 3,
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
      onFinish: () => TutorialPhaseService.instance.advanceToNextPhase(),
    ).show(context: context, rootOverlay: true);
  }
}

class _AddVolunteerAction extends StatelessWidget {
  const _AddVolunteerAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(AppIcons.add3, size: AppSizes.iconS),
      label: Text(
        'إضافة متطوع',
        style: getSemiBoldStyle(
          fontSize: FontSize.s13,
          color: ColorManager.brandStrong,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.brandStrong,
        backgroundColor: ColorManager.brandSoft,
        padding: EdgeInsets.symmetric(horizontal: Space.m),
        minimumSize: Size(0, AppHeight.s36),
        tapTargetSize: MaterialTapTargetSize.padded,
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.volunteers,
    required this.filter,
    required this.searchQuery,
    required this.filterChipsKey,
    required this.firstCardKey,
    required this.onAdd,
  });

  final List<AdminVolunteerEntity> volunteers;
  final String filter;
  final String searchQuery;
  final GlobalKey filterChipsKey;
  final GlobalKey firstCardKey;
  final VoidCallback onAdd;

  List<AdminVolunteerEntity> _applyFilters() {
    final q = searchQuery.toLowerCase();
    if (filter == 'all' && q.isEmpty) return volunteers;
    return volunteers.where((v) {
      if (filter != 'all' && v.status != filter) return false;
      if (q.isEmpty) return true;
      return v.name.toLowerCase().contains(q) ||
          (v.region?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  Future<void> _onRefresh(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final error = await context.read<VolunteersCubit>().refresh();
    if (error != null && context.mounted) {
      Toast.error.show(context, title: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _applyFilters();
    final cubit = context.read<VolunteersCubit>();
    final bottom = AppNavShell.bottomInset(context);

    return Column(
      children: [
        VolunteerFilterChips(
          key: filterChipsKey,
          volunteers: volunteers,
          selectedFilter: filter,
        ),
        SizedBox(height: Space.vm),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            color: ColorManager.brand,
            backgroundColor: ColorManager.surface,
            semanticsLabel: 'تحديث المتطوعين',
            child: displayed.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottom),
                    children: [
                      volunteers.isEmpty
                          ? AppEmptyState(
                              icon: AppIcons.group,
                              title: 'لا يوجد متطوعون بعد',
                              message: 'أضف أول متطوع ليظهر هنا',
                              actionLabel: 'إضافة متطوع',
                              onAction: onAdd,
                            )
                          : const AppEmptyState(
                              icon: AppIcons.search,
                              title: 'لا توجد نتائج مطابقة',
                              message: 'جرّب كلمة بحث أخرى أو غيّر التصفية',
                            ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      Space.gutter,
                      0,
                      Space.gutter,
                      bottom,
                    ),
                    itemCount: displayed.length,
                    separatorBuilder: (_, _) => SizedBox(height: Space.vs),
                    itemBuilder: (context, i) {
                      final v = displayed[i];
                      return KeyedSubtree(
                        key: ValueKey(v.id),
                        child: VolunteerCard(
                          key: i == 0 ? firstCardKey : null,
                          volunteer: v,
                          onTap: () async {
                            final changed = await context.push<bool>(
                              '/volunteerDetails/${v.id}',
                            );
                            if (changed == true) cubit.refresh();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

/// Rebuilds [builder] every minute. Kept tiny so only the list re-renders.
class _MinuteTicker extends StatefulWidget {
  const _MinuteTicker({required this.builder});

  final WidgetBuilder builder;

  @override
  State<_MinuteTicker> createState() => _MinuteTickerState();
}

class _MinuteTickerState extends State<_MinuteTicker> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

class _PanelSkeleton extends StatelessWidget {
  const _PanelSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Space.gutter),
          child: Skeleton(
            child: Column(
              children: [
                SkeletonBox(height: AppHeight.s48, radius: Radii.input),
                SizedBox(height: Space.vm),
                Row(
                  children: [
                    for (var i = 0; i < 4; i++) ...[
                      SkeletonBox(
                        width: AppWidth.s72,
                        height: AppHeight.s36,
                        radius: Radii.chip,
                      ),
                      SizedBox(width: Space.s),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SkeletonList(
            count: 6,
            itemHeight: AppHeight.s90,
            padding: EdgeInsets.fromLTRB(
              Space.gutter,
              Space.vm,
              Space.gutter,
              AppNavShell.bottomInset(context),
            ),
          ),
        ),
      ],
    );
  }
}
