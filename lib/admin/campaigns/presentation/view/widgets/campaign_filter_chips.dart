import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class CampaignFilterChips extends StatelessWidget {
  const CampaignFilterChips({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final void Function(String) onSelect;

  static const _filters = [
    ('all', 'الكل'),
    ('active', 'جارية'),
    ('upcoming', 'قادمة'),
    ('done', 'مكتملة'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHeight.s40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => SizedBox(width: AppWidth.s8),
        itemBuilder: (context, index) {
          final (value, label) = _filters[index];
          final isSelected = selected == value;
          return GestureDetector(
            onTap: () => onSelect(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00ABD2)
                    : const Color(0xFF0C203B),
                borderRadius: BorderRadius.circular(AppRadius.s20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00ABD2)
                      : const Color(0xFF1E3A5F),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.6),
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
