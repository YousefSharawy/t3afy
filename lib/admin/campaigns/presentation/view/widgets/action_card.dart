import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color = ColorManager.brand,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticLabel: title,
      padding: EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.vm),
      child: Row(
        children: [
          AppIconBadge(icon: icon, color: color, size: 40),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyStrong()),
                Text(subtitle, style: AppText.label()),
              ],
            ),
          ),
          const Icon(AppIcons.chevron, color: ColorManager.inkFaint),
        ],
      ),
    );
  }
}
