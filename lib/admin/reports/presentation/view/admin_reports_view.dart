import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/base/widgets/error_state.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';
import 'package:t3afy/admin/reports/presentation/cubit/admin_reports_cubit.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_report_card.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/admin_review_sheet.dart';
import 'package:t3afy/admin/reports/presentation/view/widgets/report_filter_chip.dart';

class AdminReportsView extends StatelessWidget {
  const AdminReportsView({super.key});

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
            color: ColorManager.blueOne900,
          ),
        ),
      ),
      body: BlocBuilder<AdminReportsCubit, AdminReportsState>(
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
                  SizedBox(
                    height: AppHeight.s48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppWidth.s16,
                        vertical: AppHeight.s8,
                      ),
                      children: [
                        ReportFilterChip(
                          label: 'الكل',
                          selected: filter == 'all',
                          onTap: () => cubit.setFilter('all'),
                        ),
                        SizedBox(width: AppWidth.s8),
                        ReportFilterChip(
                          label: 'قيد المراجعة',
                          selected: filter == 'pending',
                          onTap: () => cubit.setFilter('pending'),
                        ),
                        SizedBox(width: AppWidth.s8),
                        ReportFilterChip(
                          label: 'موافق عليه',
                          selected: filter == 'approved',
                          onTap: () => cubit.setFilter('approved'),
                        ),
                        SizedBox(width: AppWidth.s8),
                        ReportFilterChip(
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
                            onRefresh: () =>
                                context.read<AdminReportsCubit>().loadReports(),
                            color: const Color(0xFF00ABD2),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppWidth.s16,
                                vertical: AppHeight.s8,
                              ),
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
}
