import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'region_item.dart';

class RegionRankingSection extends StatelessWidget {
  const RegionRankingSection({super.key, required this.regions});

  final List<RegionStatEntity> regions;

  @override
  Widget build(BuildContext context) {
    if (regions.isEmpty) return const SizedBox.shrink();

    final maxCount = regions.map((r) => r.volunteerCount).reduce(
          (a, b) => a > b ? a : b,
        );

    return Container(
      padding: EdgeInsets.all(AppWidth.s16),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: ColorManager.navyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'توزيع المتطوعين حسب المنطقة',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s16),
          ...List.generate(regions.length, (i) {
            final region = regions[i];
            final fraction =
                maxCount > 0 ? region.volunteerCount / maxCount : 0.0;
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
