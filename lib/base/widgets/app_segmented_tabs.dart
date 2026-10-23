import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';

/// Index-based segmented control (replaces TasksTabSwitcher,
/// TaskDetailsTabSwitcher/TabItem and the assign-sheet tab buttons).
/// Visually identical to [PrimaryTabBar].
class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.counts,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<int?>? counts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.s44,
      padding: EdgeInsets.all(Space.xs),
      decoration: BoxDecoration(
        color: ColorManager.natural100,
        borderRadius: BorderRadius.circular(Radii.input),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selectedIndex,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => i == selectedIndex ? null : onChanged(i),
                  child: AnimatedContainer(
                    duration: AppMotion.of(context),
                    curve: AppMotion.enter,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selectedIndex
                          ? ColorManager.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Radii.small + 2),
                      boxShadow: i == selectedIndex ? AppShadows.card : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          labels[i],
                          style: i == selectedIndex
                              ? getSemiBoldStyle(
                                  fontSize: FontSize.s13,
                                  color: ColorManager.ink,
                                )
                              : getMediumStyle(
                                  fontSize: FontSize.s13,
                                  color: ColorManager.inkMuted,
                                ),
                        ),
                        if (counts != null &&
                            i < counts!.length &&
                            counts![i] != null) ...[
                          SizedBox(width: Space.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Space.xs + 2,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: i == selectedIndex
                                  ? ColorManager.brandSoft
                                  : ColorManager.natural200,
                              borderRadius: BorderRadius.circular(Radii.chip),
                            ),
                            child: Text(
                              '${counts![i]}',
                              style: getNumericStyle(
                                fontSize: FontSize.s11,
                                color: i == selectedIndex
                                    ? ColorManager.brandStrong
                                    : ColorManager.inkMuted,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
