import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
        Text(
          'تقييمك للمهمة',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s14,
            color: ColorManager.natural600,
          ),
        ),
        SizedBox(height: AppHeight.s4),
        Container(
          padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
          decoration: BoxDecoration(
            color: ColorManager.natural100,
            borderRadius: BorderRadius.circular(AppRadius.s8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => onRatingChanged(star),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s4),
                  child: star <= rating
                      ? Image.asset(IconAssets.star)
                      : Image.asset(IconAssets.unstar),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
