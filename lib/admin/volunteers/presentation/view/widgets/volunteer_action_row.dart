import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';

class VolunteerActionRow extends StatelessWidget {
  const VolunteerActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = ColorManager.brand,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Space.vs),
      child: AppCard(
        onTap: isLoading ? null : onTap,
        semanticLabel: label,
        padding: EdgeInsets.symmetric(horizontal: Space.l, vertical: Space.vm),
        child: Row(
          children: [
            isLoading
                ? SizedBox(
                    width: 36,
                    height: 36,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    ),
                  )
                : AppIconBadge(icon: icon, color: color),
            SizedBox(width: Space.m),
            Expanded(
              child: Text(
                label,
                style: AppText.bodyStrong(
                  color: color == ColorManager.error
                      ? ColorManager.error
                      : ColorManager.ink,
                ),
              ),
            ),
            const Icon(AppIcons.chevron, color: ColorManager.inkFaint),
          ],
        ),
      ),
    );
  }
}
