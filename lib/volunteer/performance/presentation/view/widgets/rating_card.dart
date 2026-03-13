import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({super.key, required this.stats});

  final PerformanceStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [Color(0xFF00ABD2), Color(0xFF02389E)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تقييمى الكلى',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueOne50,
                  fontSize: FontSize.s12,
                ),
              ),
              SizedBox(height: AppHeight.s4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '5.0/',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.blueTwo100,
                      fontSize: FontSize.s13,
                    ),
                  ),
                  SizedBox(width: 4.sp),
                  Text(
                    stats.rating.toStringAsFixed(1),
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.white,
                      fontSize: FontSize.s28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppHeight.s4),
              // Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.only(left: 2.sp),
                    child: Image.asset(IconAssets.star)
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Column(
            children: [
              Container(
                width: AppWidth.s70,
                height: AppHeight.s68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffB0DEFF).withOpacity(0.2),
                ),
                child: Center(child: Image.asset(IconAssets.trophy)),
              ),
              SizedBox(height: AppHeight.s8),
              Text(
                stats.levelTitle,
                style: getSemiBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.white,
                  fontSize: FontSize.s10,
                ),
              ),
            ],
          ),

          // Rating info
        ],
      ),
    );
  }
}
