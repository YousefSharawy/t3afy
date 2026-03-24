import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ReviewDetailCard extends StatelessWidget {
  const ReviewDetailCard({
    super.key,
    required this.title,
    required this.content,
    this.titleColor,
  });

  final String title;
  final String content;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s14),
      decoration: BoxDecoration(
        color: ColorManager.natural50,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: titleColor ?? ColorManager.cyanPrimary,
            ),
          ),
          SizedBox(height: AppHeight.s6),
          Text(
            content,
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: ColorManager.natural500,
            ),
          ),
        ],
      ),
    );
  }
}
