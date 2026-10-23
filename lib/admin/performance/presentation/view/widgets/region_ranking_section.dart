import 'package:flutter/material.dart';
import 'package:t3afy/admin/performance/domain/entities/admin_performance_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'region_item.dart';

class RegionRankingSection extends StatelessWidget {
  const RegionRankingSection({super.key, required this.regions});

  final List<RegionStatEntity> regions;

  @override
  Widget build(BuildContext context) {
    final maxCount = regions.isEmpty
        ? 0
        : regions.map((r) => r.volunteerCount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsetsDirectional.all(Space.l),
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('أكثر المناطق انضمامًا', style: AppText.bodyStrong()),
          SizedBox(height: Space.vm),
          if (regions.isEmpty)
            const AppEmptyState(
              title: 'لا توجد بيانات للمناطق',
              icon: AppIcons.location,
              compact: true,
            )
          else
            for (var i = 0; i < regions.length; i++)
              RegionItem(
                key: ValueKey(regions[i].region),
                rank: i + 1,
                region: regions[i].region,
                count: regions[i].volunteerCount,
                fraction: maxCount > 0
                    ? regions[i].volunteerCount / maxCount
                    : 0.0,
              ),
        ],
      ),
    );
  }
}
