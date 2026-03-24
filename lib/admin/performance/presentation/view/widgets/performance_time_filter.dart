import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_cubit.dart';
import 'package:t3afy/admin/performance/presentation/cubit/admin_performance_state.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PerformanceTimeFilter extends StatelessWidget {
  const PerformanceTimeFilter({super.key});

  static const _labels = ['أسبوع', 'شهور', 'سنة'];
  static const _periods = ['week', 'months', 'year'];

  String _selectedPeriod(AdminPerformanceState state) {
    if (state is AdminPerformanceLoaded) return state.selectedPeriod;
    if (state is AdminPerformanceLoading) return state.selectedPeriod;
    if (state is AdminPerformanceError) return state.selectedPeriod;
    return 'year';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminPerformanceCubit, AdminPerformanceState>(
      builder: (context, state) {
        final currentPeriod = _selectedPeriod(state);
        return Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(AppRadius.s24),
          ),
          child: Row(
            children: List.generate(_labels.length, (i) {
              final selected = _periods[i] == currentPeriod;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (selected) return;
                    context
                        .read<AdminPerformanceCubit>()
                        .loadPerformance(_periods[i]);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
                    decoration: BoxDecoration(
                      color: selected
                          ? ColorManager.primary500
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.s24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _labels[i],
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color:
                            selected ? Colors.white : ColorManager.natural400,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
