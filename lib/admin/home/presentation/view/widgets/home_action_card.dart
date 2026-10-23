import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';

/// One quick action tile: icon badge over a short label. [isLoading] swaps
/// the badge for a progress ring and disables the tap.
class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: isLoading ? null : onTap,
      padding: EdgeInsets.symmetric(horizontal: Space.s, vertical: Space.vl),
      semanticLabel: label,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 40,
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(9),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: ColorManager.brand,
                    ),
                  )
                : AppIconBadge(icon: icon, size: 40),
          ),
          SizedBox(height: Space.vs),
          Text(
            label,
            style: AppText.label(color: ColorManager.ink),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
