import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// One reading section of a report (summary, challenges, notes…).
class ReviewDetailCard extends StatelessWidget {
  const ReviewDetailCard({
    super.key,
    required this.title,
    required this.content,
    this.highlighted = false,
  });

  final String title;
  final String content;

  /// Manager feedback is tinted so it reads as a reply, not report content.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(Space.l),
      decoration: BoxDecoration(
        color: highlighted ? ColorManager.brandSoft : ColorManager.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(
          color: highlighted ? ColorManager.brandSoft : ColorManager.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.label(
              color: highlighted ? ColorManager.brandStrong : ColorManager.inkMuted,
            ),
          ),
          SizedBox(height: Space.vs),
          Text(content, style: AppText.body()),
        ],
      ),
    );
  }
}
