import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class SuppliesNoteCard extends StatelessWidget {
  const SuppliesNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
       color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملاحظة المستلزمات',
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural600,
            ),
          ),
          SizedBox(height: AppHeight.s5),
          Text(
            'جميع المستلزمات ستكون جاهزة عند نقطة التجمع. يرجى التحقق من استلام الكميات المطلوبة قبل بدء المهمة.',
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s11,
               color: ColorManager.natural400,
            ),
          ),
        ],
      ),
    );
  }
}
