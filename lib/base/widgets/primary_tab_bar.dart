import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';

/// Segmented tab bar bound to a [TabController]. For index-based tabs without
/// a controller use [AppSegmentedTabs].
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
      height: AppHeight.s44,
      padding: EdgeInsets.all(Space.xs),
      decoration: BoxDecoration(
        color: ColorManager.natural100,
        borderRadius: BorderRadius.circular(Radii.input),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: ColorManager.surface,
          borderRadius: BorderRadius.circular(Radii.small + 2),
          boxShadow: AppShadows.card,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: ColorManager.ink,
        unselectedLabelColor: ColorManager.inkMuted,
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(Radii.small),
        labelStyle: getSemiBoldStyle(fontSize: FontSize.s13),
        unselectedLabelStyle: getMediumStyle(fontSize: FontSize.s13),
        tabs: labels.map((l) => Tab(text: l)).toList(),
      ),
    );
  }
}
