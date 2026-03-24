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
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';

class VolunteersPanelView extends StatelessWidget {
  const VolunteersPanelView({super.key});

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
        body: BlocBuilder<VolunteersCubit, VolunteersState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const LoadingIndicator(),
              error: (message) => ErrorState(
                message: message,
                onRetry: () => context.read<VolunteersCubit>().loadVolunteers(),
              ),
              loaded: (volunteers, filter, searchQuery, pendingUsers, pendingLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
                  child: Column(
                    children: [
                      SizedBox(height: AppHeight.s16),
                      const VolunteerSearchBar(),
                      SizedBox(height: AppHeight.s16),
                      VolunteerFilterChips(
                        volunteers: volunteers,
                        selectedFilter: filter,
                      ),
                      SizedBox(height: AppHeight.s8),
                      Expanded(
                        child: _buildVolunteerList(
                          context,
                          _applyFilters(volunteers,
                              filter: filter, searchQuery: searchQuery),
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

  Widget _buildVolunteerList(
      BuildContext context, List<AdminVolunteerEntity> displayed) {
    if (displayed.isEmpty) {
      return const EmptyStateText(message: 'لا يوجد متطوعون');
    }
    final cubit = context.read<VolunteersCubit>();
    return RefreshIndicator(
      onRefresh: () => cubit.loadVolunteers(),
      color: ColorManager.primary500,
      child: ListView.builder(
        itemCount: displayed.length,
        itemBuilder: (context, i) => VolunteerCard(
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
