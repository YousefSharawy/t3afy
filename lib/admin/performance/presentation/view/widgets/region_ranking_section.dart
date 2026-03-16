import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
        border: Border.all(color: const Color(0xFF1E3A5F)),
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
            return _RegionItem(
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

class _RegionItem extends StatelessWidget {
  const _RegionItem({
    required this.rank,
    required this.region,
    required this.count,
    required this.fraction,
  });

  final int rank;
  final String region;
  final int count;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             
              Expanded(
                child: Text(
                  region,
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.blueOne50,
                  ),
                ),
              ),
              Text(
                '$count متطوع',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: const Color(0xFF0095FF),
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6.h,
              backgroundColor: const Color(0xFF1E3A5F),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00ABD2)),
            ),
          ),
        ],
      ),
    );
  }
}
