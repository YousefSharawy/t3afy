import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF143764),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'تقييمك للمهمة',
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppHeight.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => onRatingChanged(star),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s4),
                  child: Icon(
                    star <= rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: star <= rating
                        ? const Color(0xFFFBBF24)
                        : Colors.white.withValues(alpha: 0.3),
                    size: 36.r,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
