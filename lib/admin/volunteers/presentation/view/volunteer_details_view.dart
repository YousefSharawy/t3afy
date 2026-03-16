import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_data_tab.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_details_header.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_manage_tab.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_tasks_tab.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';

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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.blueOne900,
              size: 20.sp,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<VolunteerDetailsCubit, VolunteerDetailsState>(
          listener: (context, state) {
            if (state is VolunteerDetailsDeleted) {
              context.pop(true);
            } else if (state is VolunteerDetailsActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VolunteerDetailsLoading ||
                state is VolunteerDetailsInitial) {
              return const LoadingIndicator();
            }
            if (state is VolunteerDetailsError) {
              return ErrorState(
                message: state.message,
                onRetry: () => context
                    .read<VolunteerDetailsCubit>()
                    .load(widget.volunteerId),
              );
            }

            VolunteerDetailsEntity? details;
            if (state is VolunteerDetailsLoaded) {
              details = state.details;
            } else if (state is VolunteerDetailsDeleting) {
              details = state.details;
            } else if (state is VolunteerDetailsActionError) {
              details = state.details;
            }

            if (details == null) return const LoadingIndicator();

            return Column(
              children: [
                SizedBox(height: AppHeight.s8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  child: VolunteerDetailsHeader(details: details),
                ),
                SizedBox(height: AppHeight.s12),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  decoration: BoxDecoration(
                    color: ColorManager.blueOne800,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    border: Border.all(color: ColorManager.blueOne700),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF00ABD2),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: const Color(0xFF00ABD2),
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
                    dividerColor: Colors.transparent,
                    labelStyle: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s12,
                    ),
                    tabs: const [
                      Tab(text: 'البيانات'),
                      Tab(text: 'المهام'),
                      Tab(text: 'الإجراءات'),
                    ],
                  ),
                ),
                SizedBox(height: AppHeight.s8),
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
            );
          },
        ),
      ),
    );
  }
}
