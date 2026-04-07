import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/add_volunteer_sheet.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_card.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_filter_chips.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_search_bar.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
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

    debugPrint('📘 TUTORIAL: Volunteers screen starting phase 2, marking _lastCheckedPhase=2');
    _lastCheckedPhase = 2; // Mark immediately since volunteers list renders synchronously
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _showVolunteersTutorial();
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'ادارة المتطوعين',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s16,
              color: ColorManager.natural900,
            ),
          ),
          leadingWidth: AppWidth.s110,
          leading: Padding(
            padding: EdgeInsets.only(right: AppWidth.s18),
            child: PrimaryElevatedButton(
              backGroundColor: ColorManager.primary50,
              borderColor: ColorManager.primary500,
              buttonRadius: AppRadius.s20,
              iconPath: IconAssets.add,
              textStyle: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.primary500,
              ),
              height: AppHeight.s26,
              title: "إضافة متطوع",
              onPress: () {
                HapticFeedback.mediumImpact();
                final cubit = context.read<VolunteersCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const AddVolunteerSheet(),
                  ),
                );
              },
            ),
          ),
        ),
        body: BlocConsumer<VolunteersCubit, VolunteersState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (_, _, _, _, _) {
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
                onRetry: () => context.read<VolunteersCubit>().loadVolunteers(),
              ),
              loaded:
                  (
                    volunteers,
                    filter,
                    searchQuery,
                    pendingUsers,
                    pendingLoading,
                  ) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
                      child: Column(
                        children: [
                          SizedBox(height: AppHeight.s16),
                          VolunteerSearchBar(key: _searchBarKey),
                          SizedBox(height: AppHeight.s16),
                          VolunteerFilterChips(
                            key: _filterChipsKey,
                            volunteers: volunteers,
                            selectedFilter: filter,
                          ),
                          SizedBox(height: AppHeight.s8),
                          Expanded(
                            child: _buildVolunteerList(
                              context,
                              _applyFilters(
                                volunteers,
                                filter: filter,
                                searchQuery: searchQuery,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
            );
          },
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
      debugPrint(
        '📘 TUTORIAL: AdminVolunteers screen has no targets, advancing to next phase',
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

  Widget _buildVolunteerList(
    BuildContext context,
    List<AdminVolunteerEntity> displayed,
  ) {
    if (displayed.isEmpty) {
      return const EmptyStateText(message: 'لا يوجد متطوعون');
    }
    final cubit = context.read<VolunteersCubit>();
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        try {
          await cubit.loadVolunteers();
          HapticFeedback.lightImpact();
        } catch (e) {
          HapticFeedback.heavyImpact();
        }
      },
      color: ColorManager.white,
      backgroundColor: ColorManager.primary500,
      displacement: 40.0,
      strokeWidth: 2.5,
      semanticsLabel: 'تحديث المتطوعين',
      semanticsValue: '0%',
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: displayed.length,
        itemBuilder: (context, i) => VolunteerCard(
          key: i == 0 ? _firstCardKey : null,
          volunteer: displayed[i],
          onTap: () async {
            final changed = await context.push<bool>(
              '/volunteerDetails/${displayed[i].id}',
            );
            if (changed == true && context.mounted) {
              cubit.loadVolunteers();
            }
          },
        ),
      ),
    );
  }

  List<AdminVolunteerEntity> _applyFilters(
    List<AdminVolunteerEntity> all, {
    required String filter,
    required String searchQuery,
  }) {
    var list = all;
    if (filter != 'all') {
      list = list.where((v) => v.status == filter).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where(
            (v) =>
                v.name.toLowerCase().contains(q) ||
                (v.region?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    return list;
  }
}
