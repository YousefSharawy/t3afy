import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/filter_chip_item.dart';

class VolunteerFilterChips extends StatelessWidget {
  const VolunteerFilterChips({
    super.key,
    required this.volunteers,
    required this.selectedFilter,
  });

  final List<AdminVolunteerEntity> volunteers;
  final String selectedFilter;

  @override
  Widget build(BuildContext context) {
    final total = volunteers.length;
    final active = volunteers.where((v) => v.status == 'نشط').length;
    final pending = volunteers.where((v) => v.status == 'قيد المراجعة').length;
    final inactive = volunteers.where((v) => v.status == 'غير نشط').length;

    final cubit = context.read<VolunteersCubit>();

    return SizedBox(
      height: AppHeight.s29,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChipItem(
            label: 'الكل ($total)',
            selected: selectedFilter == 'all',
            onTap: () => cubit.setFilter('all'),
          ),
          SizedBox(width: AppWidth.s8),
          FilterChipItem(
            label: 'نشيطون ($active)',
            selected: selectedFilter == 'نشط',
            onTap: () => cubit.setFilter('نشط'),
          ),
          SizedBox(width: AppWidth.s8),
          FilterChipItem(
            label: 'قيد المراجعة ($pending)',
            selected: selectedFilter == 'قيد المراجعة',
            onTap: () => cubit.setFilter('قيد المراجعة'),
          ),
          SizedBox(width: AppWidth.s8),
          FilterChipItem(
            label: 'غير نشط ($inactive)',
            selected: selectedFilter == 'غير نشط',
            onTap: () => cubit.setFilter('غير نشط'),
          ),
        ],
      ),
    );
  }
}
