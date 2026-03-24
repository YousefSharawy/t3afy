import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PrimaryTabBar extends StatelessWidget {
  const PrimaryTabBar({
    super.key,
    required this.controller,
    required this.labels,
  });

  final TabController controller;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.s50,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s24),
      ),
      child: TabBar(
        padding: EdgeInsets.all(8.sp),
        controller: controller,
        indicator: BoxDecoration(
          color: ColorManager.primary500,
          borderRadius: BorderRadius.circular(AppRadius.s24),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorManager.primary50,
        unselectedLabelColor: ColorManager.natural300,
        dividerColor: Colors.transparent,
        labelStyle: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s12,
        ),
        tabs: labels.map((l) => Tab(text: l)).toList(),
      ),
    );
  }
}
