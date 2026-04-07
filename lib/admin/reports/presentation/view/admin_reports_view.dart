import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_report_card.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_review_sheet.dart';
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

    debugPrint('📘 TUTORIAL: Reports screen starting phase 4, marking _lastCheckedPhase=4');
    _lastCheckedPhase = 4; // Mark immediately since reports list renders synchronously
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showReportsTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تقارير المهام',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: ColorManager.natural900,
          ),
        ),
      ),
      body: BlocConsumer<AdminReportsCubit, AdminReportsState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (_, filter) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _checkTutorial(),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LoadingIndicator(),
            error: (message) => ErrorState(
              message: message,
              onRetry: () => context.read<AdminReportsCubit>().loadReports(),
            ),
            loaded: (reports, filter) {
              final cubit = context.read<AdminReportsCubit>();
              final list = filter == 'all'
                  ? reports
                  : reports.where((r) => r.status == filter).toList();
              return Column(
                children: [
                  SizedBox(height: AppHeight.s10),
                  SizedBox(
                    key: _filterRowKey,
                    height: AppHeight.s48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppWidth.s16,
                        vertical: AppHeight.s8,
                      ),
                      children: [
                        FilterChipItem(
                          label: 'الكل',
                          selected: filter == 'all',
                          onTap: () => cubit.setFilter('all'),
                        ),
                        SizedBox(width: AppWidth.s8),
                        FilterChipItem(
                          label: 'قيد المراجعة',
                          selected: filter == 'pending',
                          onTap: () => cubit.setFilter('pending'),
                        ),
                        SizedBox(width: AppWidth.s8),
                        FilterChipItem(
                          label: 'موافق عليه',
                          selected: filter == 'approved',
                          onTap: () => cubit.setFilter('approved'),
                        ),
                        SizedBox(width: AppWidth.s8),
                        FilterChipItem(
                          label: 'مرفوض',
                          selected: filter == 'rejected',
                          onTap: () => cubit.setFilter('rejected'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: list.isEmpty
                        ? const EmptyStateText(message: 'لا توجد تقارير')
                        : RefreshIndicator(
                            onRefresh: () async {
                              HapticFeedback.mediumImpact();
                              try {
                                await context.read<AdminReportsCubit>().loadReports();
                                HapticFeedback.lightImpact();
                              } catch (e) {
                                HapticFeedback.heavyImpact();
                              }
                            },
                            color: ColorManager.white,
                            backgroundColor: ColorManager.primary500,
                            displacement: 40.0,
                            strokeWidth: 2.5,
                            semanticsLabel: 'تحديث التقارير',
                            semanticsValue: '0%',
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppWidth.s16,
                                vertical: AppHeight.s8,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, i) => AdminReportCard(
                                report: list[i],
                                onTap: () async {
                                  final refreshed =
                                      await showModalBottomSheet<bool>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => BlocProvider.value(
                                          value: cubit,
                                          child: AdminReviewSheet(
                                            report: list[i],
                                          ),
                                        ),
                                      );
                                  if (refreshed == true && context.mounted) {
                                    context
                                        .read<AdminReportsCubit>()
                                        .loadReports();
                                  }
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
            reviewing: () => const LoadingIndicator(),
            reviewed: () => const LoadingIndicator(),
          );
        },
      ),
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
      debugPrint(
        '📘 TUTORIAL: AdminReports screen has no targets, advancing to next phase',
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
