import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'form_field_label.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
  });

  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String Function(String)? itemLabel;

  String _label(String v) => itemLabel != null ? itemLabel!(v) : v;

  @override
  Widget build(BuildContext context) {
    final textStyle = getMediumStyle(fontSize: FontSize.s15, color: ColorManager.ink);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label),
        SizedBox(height: Space.vs),
        PopupMenuButton<String>(
          onSelected: onChanged,
          position: PopupMenuPosition.under,
          color: ColorManager.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.input),
          ),
          itemBuilder: (context) => [
            for (final e in items)
              PopupMenuItem<String>(
                value: e,
                child: Text(
                  _label(e),
                  style: e == value
                      ? getSemiBoldStyle(fontSize: FontSize.s14, color: ColorManager.brand)
                      : getMediumStyle(fontSize: FontSize.s14, color: ColorManager.ink),
                ),
              ),
          ],
          child: Container(
            constraints: BoxConstraints(minHeight: AppSizes.touch),
            padding: EdgeInsets.symmetric(horizontal: Space.m),
            decoration: BoxDecoration(
              color: ColorManager.surfaceSunken,
              border: Border.all(color: ColorManager.line),
              borderRadius: BorderRadius.circular(Radii.input),
            ),
            child: Row(
              children: [
                Expanded(child: Text(_label(value), style: textStyle)),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ColorManager.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
