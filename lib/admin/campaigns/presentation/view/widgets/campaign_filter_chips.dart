import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class CampaignFilterChips extends StatelessWidget {
  const CampaignFilterChips({
    super.key,
    required this.selected,
    required this.onSelect,
    this.counts = const {},
  });

  final String selected;
  final void Function(String) onSelect;
  final Map<String, int> counts;

  static const _filters = [
    ('all', 'الكل'),
    ('active', 'جارية'),
    ('upcoming', 'قادمة'),
    ('done', 'مكتملة'),
    ('missed', 'فائت'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHeight.s29,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s18),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: AppWidth.s9),
        itemBuilder: (context, index) {
          final (value, label) = _filters[index];
          final isSelected = selected == value;
          final count = counts[value] ?? 0;
          return GestureDetector(
            onTap: () => onSelect(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: AppWidth.s10,
                vertical: AppHeight.s5,
              ),
              decoration: BoxDecoration(
                color: ColorManager.primary500,
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Center(
                child: Text(
                  '$label ($count)',
                  style: isSelected
                      ? getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.white,
                        )
                      : getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.primary50,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
