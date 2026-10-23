import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/reports/domain/entities/admin_report_entity.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_report_card.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_review_sheet.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_nav_shell.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/filter_chip_item.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({super.key});

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  final GlobalKey _filterRowKey = GlobalKey();

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
    if (svc.currentPhase != 4 || !svc.isAdmin) return;
    if (_lastCheckedPhase == 4) return; // Already showed phase 4

    _lastCheckedPhase = 4; // Mark immediately since reports list renders synchronously
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showReportsTutorial();
    });
  }

  static const _filters = [
    ('all', 'الكل'),
    ('pending', 'قيد المراجعة'),
    ('approved', 'موافق عليه'),
    ('rejected', 'مرفوض'),
  ];

  Future<void> _refresh(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final error = await context.read<AdminReportsCubit>().refresh();
    if (error != null && context.mounted) {
      Toast.error.show(context, title: error);
    }
  }

  void _openReview(BuildContext context, AdminReportEntity report) {
    final cubit = context.read<AdminReportsCubit>();
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AdminReviewSheet(report: report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(
              title: 'مراجعة التقارير',
              reserveBellSpace: true,
            ),
            Expanded(
              child: BlocConsumer<AdminReportsCubit, AdminReportsState>(
                // reviewing / reviewed are no longer emitted; never let an
                // action state blank the list.
                buildWhen: (_, curr) => curr.maybeWhen(
                  reviewing: () => false,
                  reviewed: () => false,
                  orElse: () => true,
                ),
                listenWhen: (prev, curr) =>
                    curr.maybeWhen(loaded: (_, _) => true, orElse: () => false) &&
                    !prev.maybeWhen(loaded: (_, _) => true, orElse: () => false),
                listener: (context, state) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _checkTutorial(),
                  );
                },
                builder: (context, state) {
                  final cubit = context.read<AdminReportsCubit>();
                  return AppAsyncBody(
                    hasData: state.maybeWhen(
                      loaded: (_, _) => true,
                      orElse: () => false,
                    ),
                    errorMessage: state.maybeWhen(
                      error: (m) => m,
                      orElse: () => null,
                    ),
                    onRetry: cubit.loadReports,
                    skeleton: SkeletonList(
                      count: 6,
                      itemHeight: 96,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: Space.gutter,
                        vertical: Space.vs,
                      ),
                    ),
                    builder: (context) => state.maybeWhen(
                      loaded: (reports, filter) =>
                          _buildLoaded(context, reports, filter),
                      orElse: () => const SizedBox.shrink(),
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

  Widget _buildLoaded(
    BuildContext context,
    List<AdminReportEntity> reports,
    String filter,
  ) {
    final cubit = context.read<AdminReportsCubit>();
    final list = filter == 'all'
        ? reports
        : reports.where((r) => r.status == filter).toList();
    int countOf(String f) => f == 'all'
        ? reports.length
        : reports.where((r) => r.status == f).length;
    final bottom = AppNavShell.bottomInset(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          key: _filterRowKey,
          height: AppSizes.touch,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Space.gutter,
              vertical: Space.vxs,
            ),
            itemCount: _filters.length,
            separatorBuilder: (_, _) => SizedBox(width: Space.s),
            itemBuilder: (_, i) {
              final (key, label) = _filters[i];
              return FilterChipItem(
                label: label,
                count: countOf(key),
                selected: filter == key,
                onTap: () => cubit.setFilter(key),
              );
            },
          ),
        ),
        SizedBox(height: Space.vs),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refresh(context),
            color: ColorManager.brand,
            backgroundColor: ColorManager.surface,
            semanticsLabel: 'تحديث التقارير',
            child: list.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      top: Space.vxl,
                      bottom: bottom,
                    ),
                    children: [
                      AppEmptyState(
                        title: filter == 'pending'
                            ? 'لا توجد تقارير بانتظار المراجعة'
                            : 'لا توجد تقارير',
                        message: 'تظهر هنا تقارير المتطوعين بعد إنهاء مهامهم.',
                        icon: AppIcons.reports,
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsetsDirectional.fromSTEB(
                      Space.gutter,
                      Space.vxs,
                      Space.gutter,
                      bottom,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, i) => AdminReportCard(
                      key: ValueKey(list[i].id),
                      report: list[i],
                      onTap: () => _openReview(context, list[i]),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showReportsTutorial() {
    final targets = <TargetFocus>[];

    if (_filterRowKey.currentContext != null) {
      targets.add(
        TutorialService.buildTarget(
          identify: 'reports_filter',
          keyTarget: _filterRowKey,
          title: 'تقارير المتطوعين',
          description:
              'راجع التقارير ووافق عليها أو ارفضها لاحتساب ساعات المتطوع',
          contentAlign: ContentAlign.bottom,
          stepIndex: 1,
          totalSteps: 1,
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
