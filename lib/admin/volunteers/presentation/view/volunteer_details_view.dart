import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_data_tab.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_details_header.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_manage_tab.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_tasks_tab.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/primary_tab_bar.dart';

class VolunteerDetailsView extends StatefulWidget {
  const VolunteerDetailsView({super.key, required this.volunteerId});

  final String volunteerId;

  @override
  State<VolunteerDetailsView> createState() => _VolunteerDetailsViewState();
}

class _VolunteerDetailsViewState extends State<VolunteerDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<VolunteerDetailsCubit>().load(widget.volunteerId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// The single place that closes this screen after delete / suspend /
  /// approve / reject (the manage tab used to pop too → double pop).
  void _listener(BuildContext context, VolunteerDetailsState state) {
    if (state is VolunteerDetailsDeleted) {
      Toast.success.show(context, title: 'تم حذف المتطوع');
      context.pop(true);
    } else if (state is VolunteerDetailsSuspended) {
      Toast.success.show(context, title: 'تم تعليق الحساب');
      context.pop(true);
    } else if (state is VolunteerDetailsDecided) {
      Toast.success.show(context, title: state.message);
      context.pop(true);
    } else if (state is VolunteerDetailsActionError) {
      Toast.error.show(context, title: state.message);
    }
  }

  /// Rebuild only when the details object changes or the screen switches
  /// between skeleton / error / data — action progress never blanks the view.
  bool _buildWhen(VolunteerDetailsState prev, VolunteerDetailsState curr) {
    final next = curr.detailsOrNull;
    if (next == null) {
      return curr is VolunteerDetailsLoading ||
          curr is VolunteerDetailsError ||
          curr is VolunteerDetailsInitial;
    }
    return !identical(prev.detailsOrNull, next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.canvas,
      // No fields on this page; the action sheets lift themselves above the
      // keyboard. Resizing here would squeeze the fixed header + tabs behind
      // the sheet and overflow on short screens.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: 'بيانات المتطوع',
              showBack: true,
              actions: const [_ExportAction()],
            ),
            Expanded(
              child: BlocConsumer<VolunteerDetailsCubit, VolunteerDetailsState>(
                listener: _listener,
                buildWhen: _buildWhen,
                builder: (context, state) {
                  if (state is VolunteerDetailsError) {
                    return ErrorState(
                      message: state.message,
                      onRetry: () => context.read<VolunteerDetailsCubit>().load(
                        widget.volunteerId,
                      ),
                    );
                  }
                  final details = state.detailsOrNull;
                  if (details == null) return const _DetailsSkeleton();

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: Space.gutter),
                    child: Column(
                      children: [
                        VolunteerDetailsHeader(details: details),
                        SizedBox(height: Space.vl),
                        PrimaryTabBar(
                          controller: _tabController,
                          labels: const ['البيانات', 'المهام', 'الإجراءات'],
                        ),
                        SizedBox(height: Space.vm),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              VolunteerDataTab(details: details),
                              VolunteerTasksTab(details: details),
                              VolunteerManageTab(details: details),
                            ],
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
}

/// PDF export in the header; spins only while exporting (not for other actions).
class _ExportAction extends StatelessWidget {
  const _ExportAction();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolunteerDetailsCubit, VolunteerDetailsState>(
      buildWhen: (p, c) =>
          (p is VolunteerDetailsExporting) !=
              (c is VolunteerDetailsExporting) ||
          (p.detailsOrNull == null) != (c.detailsOrNull == null),
      builder: (context, state) {
        final details = state.detailsOrNull;
        if (details == null) return const SizedBox.shrink();
        if (state is VolunteerDetailsExporting) {
          return SizedBox(
            width: AppSizes.touch,
            height: AppSizes.touch,
            child: Center(
              child: SizedBox(
                width: AppSizes.iconM,
                height: AppSizes.iconM,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorManager.brand,
                ),
              ),
            ),
          );
        }
        return IconButton(
          tooltip: 'تصدير بيانات المتطوع PDF',
          icon: const Icon(AppIcons.pdf, color: ColorManager.brand),
          onPressed: () =>
              context.read<VolunteerDetailsCubit>().exportVolunteerPdf(details),
        );
      },
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Space.gutter),
      child: Skeleton(
        child: Column(
          children: [
            SkeletonBox(height: AppHeight.s200, radius: Radii.card),
            SizedBox(height: Space.vl),
            SkeletonBox(height: AppHeight.s44, radius: Radii.input),
            SizedBox(height: Space.vm),
            for (var i = 0; i < 4; i++) ...[
              SkeletonBox(height: AppHeight.s56, radius: Radii.card),
              SizedBox(height: Space.vs),
            ],
          ],
        ),
      ),
    );
  }
}
