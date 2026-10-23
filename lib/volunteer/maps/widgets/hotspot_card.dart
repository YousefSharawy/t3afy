import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'hotspot.dart';

class HotspotCard extends StatelessWidget {
  const HotspotCard({super.key, required this.hotspot});

  final Hotspot hotspot;

  @override
  Widget build(BuildContext context) {
    final s = hotspot.severity;
    final cases = hotspot.cases;
    return AppCard(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Space.m,
        vertical: Space.vm,
      ),
      child: Row(
        children: [
          AppIconBadge(icon: AppIcons.location, color: s.color),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotspot.name, style: AppText.bodyStrong()),
                Text(
                  '$cases ${cases == 1 ? 'حالة مرصودة' : 'حالات مرصودة'}',
                  style: AppText.caption(),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Space.m,
              vertical: Space.vxs,
            ),
            decoration: BoxDecoration(
              color: s.soft,
              borderRadius: BorderRadius.circular(Radii.chip),
            ),
            child: Text(s.label, style: AppText.label(color: s.color)),
          ),
        ],
      ),
    );
  }
}
