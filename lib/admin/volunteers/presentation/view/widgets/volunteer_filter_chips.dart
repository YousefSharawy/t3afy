import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/admin_volunteer_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
      height: AppHeight.s48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s8,
        ),
        children: [
          _Chip(
            label: 'الكل ($total)',
            selected: selectedFilter == 'all',
            onTap: () => cubit.setFilter('all'),
          ),
          SizedBox(width: AppWidth.s8),
          _Chip(
            label: 'نشيطون ($active)',
            selected: selectedFilter == 'نشط',
            onTap: () => cubit.setFilter('نشط'),
          ),
          SizedBox(width: AppWidth.s8),
          _Chip(
            label: 'قيد المراجعة ($pending)',
            selected: selectedFilter == 'قيد المراجعة',
            onTap: () => cubit.setFilter('قيد المراجعة'),
          ),
          SizedBox(width: AppWidth.s8),
          _Chip(
            label: 'غير نشط ($inactive)',
            selected: selectedFilter == 'غير نشط',
            onTap: () => cubit.setFilter('غير نشط'),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00ABD2) : const Color(0xFF0C203B),
          borderRadius: BorderRadius.circular(AppRadius.s20),
          border: Border.all(
            color: selected
                ? const Color(0xFF00ABD2)
                : const Color(0xFF1E3A5F),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
