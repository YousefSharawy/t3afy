import 'package:flutter/material.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'volunteer_picker_sheet.dart';

/// The chosen team inside the campaign form, plus the button that opens the
/// picker.
class VolunteerSelectionList extends StatelessWidget {
  const VolunteerSelectionList({
    super.key,
    required this.selectedVolunteers,
    required this.onRemove,
    required this.onAddPressed,
  });

  final List<VolunteerEntity> selectedVolunteers;
  final void Function(String id) onRemove;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final v in selectedVolunteers) ...[
          VolunteerRow(
            key: ValueKey(v.id),
            volunteer: v,
            color: ColorManager.surfaceSunken,
            trailing: IconButton(
              tooltip: 'إزالة',
              onPressed: () => onRemove(v.id),
              icon: const Icon(AppIcons.x, color: ColorManager.inkFaint),
            ),
          ),
          SizedBox(height: Space.vs),
        ],
        OutlinedButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(AppIcons.add3, size: 20),
          label: Text(
            selectedVolunteers.isEmpty ? 'اختيار المتطوعين' : 'تعديل الفريق',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorManager.brand,
            side: const BorderSide(color: ColorManager.brand),
            minimumSize: Size(double.infinity, AppSizes.touch),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.input),
            ),
          ),
        ),
      ],
    );
  }
}
