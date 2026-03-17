import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'volunteer_selection_card.dart';

class VolunteerSelectionList extends StatelessWidget {
  const VolunteerSelectionList({
    super.key,
    required this.volunteers,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<VolunteerEntity> volunteers;
  final Set<String> selectedIds;
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    if (volunteers.isEmpty) {
      return Center(
        child: Text(
          'جارٍ التحميل...',
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: ColorManager.blueOne300,
          ),
        ),
      );
    }

    return Column(
      children: volunteers.map((v) {
        return VolunteerSelectionCard(
          volunteer: v,
          isSelected: selectedIds.contains(v.id),
          onTap: () => onToggle(v.id),
        );
      }).toList(),
    );
  }
}
