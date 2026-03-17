import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class RegionItem extends StatelessWidget {
  const RegionItem({
    super.key,
    required this.rank,
    required this.region,
    required this.count,
    required this.fraction,
  });

  final int rank;
  final String region;
  final int count;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  region,
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.blueOne50,
                  ),
                ),
              ),
              Text(
                '$count متطوع',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s12,
                  color: const Color(0xFF0095FF),
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6.h,
              backgroundColor: ColorManager.navyLight,
              valueColor: const AlwaysStoppedAnimation(ColorManager.cyanPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
