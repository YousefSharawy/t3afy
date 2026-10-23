import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Label / value row inside the review sheet's facts card.
class ReviewInfoRow extends StatelessWidget {
  const ReviewInfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Space.l,
        vertical: Space.vm,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconM, color: ColorManager.inkFaint),
          SizedBox(width: Space.m),
          Text(label, style: AppText.label()),
          SizedBox(width: Space.m),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child:
                  trailing ??
                  Text(
                    value ?? '',
                    textAlign: TextAlign.end,
                    style: getNumericStyle(color: ColorManager.ink),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
