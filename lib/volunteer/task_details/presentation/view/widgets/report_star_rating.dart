import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

class ReportStarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const ReportStarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تقييمك للمهمة', style: AppText.label(color: ColorManager.ink)),
        SizedBox(height: Space.vs),
        Container(
          padding: EdgeInsets.symmetric(vertical: Space.vxs),
          decoration: BoxDecoration(
            color: ColorManager.surfaceSunken,
            borderRadius: BorderRadius.circular(Radii.input),
            border: Border.all(color: ColorManager.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              final filled = star <= rating;
              return IconButton(
                tooltip: '$star من 5',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onRatingChanged(star);
                },
                icon: Icon(
                  filled ? AppIcons.star : AppIcons.unstar,
                  size: 32,
                  color: filled ? ColorManager.star : ColorManager.natural300,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
