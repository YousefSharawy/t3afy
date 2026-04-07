import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'region_item.dart';

class RegionRankingSection extends StatelessWidget {
  const RegionRankingSection({super.key, required this.regions});

  final List<RegionStatEntity> regions;

  @override
  Widget build(BuildContext context) {
    if (regions.isEmpty) {
      return const EmptyStateText(message: 'لا توجد بيانات للمناطق');
    }

    final maxCount = regions
        .map((r) => r.volunteerCount)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s18,
        horizontal: AppWidth.s11,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(regions.length, (i) {
            final region = regions[i];
            final fraction = maxCount > 0
                ? region.volunteerCount / maxCount
                : 0.0;
            return RegionItem(
              rank: i + 1,
              region: region.region,
              count: region.volunteerCount,
              fraction: fraction,
            );
          }),
        ],
      ),
    );
  }
}
