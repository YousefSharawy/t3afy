import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/filter_chip_item.dart';
import 'package:t3afy/base/widgets/status_badge.dart';

/// Status filter. Keys stay the entity's Arabic status strings (data
/// contract); labels come from [StatusBadge.styleOf] so wording matches badges.
class VolunteerFilterChips extends StatelessWidget {
  const VolunteerFilterChips({
    super.key,
    required this.volunteers,
    required this.selectedFilter,
  });

  static const statusKeys = ['نشط', 'قيد المراجعة', 'غير نشط'];

  final List<AdminVolunteerEntity> volunteers;
  final String selectedFilter;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{for (final k in statusKeys) k: 0};
    for (final v in volunteers) {
      counts.update(v.status, (c) => c + 1, ifAbsent: () => 1);
    }
    final cubit = context.read<VolunteersCubit>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Space.gutter),
      child: Row(
        children: [
          FilterChipItem(
            label: 'الكل',
            count: volunteers.length,
            selected: selectedFilter == 'all',
            onTap: () => cubit.setFilter('all'),
          ),
          for (final key in statusKeys) ...[
            SizedBox(width: Space.s),
            FilterChipItem(
              label: StatusBadge.styleOf(key).label,
              count: counts[key],
              selected: selectedFilter == key,
              onTap: () => cubit.setFilter(key),
            ),
          ],
        ],
      ),
    );
  }
}
