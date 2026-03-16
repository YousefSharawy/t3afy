import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_card.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_filter_chips.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_search_bar.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
          backgroundColor: ColorManager.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: AppWidth.s16,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Teal action button on left (RTL: appears on left of screen)
              TextButton.icon(
                onPressed: () {
                  // TODO: Add volunteer
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
                label: Text(
                  'إضافة متطوع +',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF00ABD2),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s12,
                    vertical: AppHeight.s8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                ),
              ),
              // Title on right
              Text(
                'ادارة المتطوعين',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s16,
                  color: ColorManager.blueOne900,
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<VolunteersCubit, VolunteersState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const LoadingIndicator(),
              error: (message) => ErrorState(
                message: message,
                onRetry: () =>
                    context.read<VolunteersCubit>().loadVolunteers(),
              ),
              loaded: (volunteers, filter, searchQuery) {
                final displayed = _applyFilters(
                  volunteers,
                  filter: filter,
                  searchQuery: searchQuery,
                );
                return Column(
                  children: [
                    const VolunteerSearchBar(),
                    VolunteerFilterChips(
                      volunteers: volunteers,
                      selectedFilter: filter,
                    ),
                    Expanded(
                      child: displayed.isEmpty
                          ? Center(
                              child: Text(
                                'لا يوجد متطوعون',
                                style: getMediumStyle(
                                  fontFamily: FontConstants.fontFamily,
                                  fontSize: FontSize.s14,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => context
                                  .read<VolunteersCubit>()
                                  .loadVolunteers(),
                              color: const Color(0xFF00ABD2),
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppWidth.s16,
                                  vertical: AppHeight.s8,
                                ),
                                itemCount: displayed.length,
                                itemBuilder: (context, i) =>
                                    VolunteerCard(volunteer: displayed[i]),
                              ),
                            ),
                    ),
                  ],
                );
              },
            );
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
