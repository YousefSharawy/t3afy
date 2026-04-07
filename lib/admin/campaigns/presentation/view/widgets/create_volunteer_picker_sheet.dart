import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'volunteer_picker_row.dart';

class CreateVolunteerPickerSheet extends StatefulWidget {
  const CreateVolunteerPickerSheet({
    super.key,
    required this.volunteers,
    required this.alreadySelected,
    required this.onConfirm,
  });

  final List<VolunteerEntity> volunteers;
  final Set<String> alreadySelected;
  final void Function(Set<String> ids) onConfirm;

  @override
  State<CreateVolunteerPickerSheet> createState() =>
      _CreateVolunteerPickerSheetState();
}

class _CreateVolunteerPickerSheetState
    extends State<CreateVolunteerPickerSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.alreadySelected);
  }

  bool get _allSelected =>
      widget.volunteers.isNotEmpty &&
      widget.volunteers.every((v) => _selected.contains(v.id));

  void _toggle(String id) => setState(() {
    if (_selected.contains(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }
  });

  void _toggleAll() => setState(() {
    if (_allSelected) {
      _selected.removeAll(widget.volunteers.map((v) => v.id));
    } else {
      _selected.addAll(widget.volunteers.map((v) => v.id));
    }
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: ColorManager.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              SizedBox(height: AppHeight.s12),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorManager.natural200,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppHeight.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                child: Row(
                  children: [
                    Text(
                      'إضافة متطوعين',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s16,
                        color: ColorManager.natural700,
                      ),
                    ),
                    const Spacer(),
                    if (_selected.isNotEmpty)
                      Text(
                        'تم تحديد ${_selected.length} متطوع',
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s14,
                          color: ColorManager.primary500,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.volunteers.isNotEmpty) ...[
                SizedBox(height: AppHeight.s8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: _toggleAll,
                      child: Text(
                        _allSelected ? 'إلغاء التحديد' : 'تحديد الكل',
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s13,
                          color: ColorManager.primary500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppHeight.s8),
              Expanded(
                child: widget.volunteers.isEmpty
                    ? Center(
                        child: Text(
                          'لا يوجد متطوعون متاحون',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s14,
                            color: ColorManager.natural400,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                        itemCount: widget.volunteers.length,
                        itemBuilder: (context, i) {
                          final v = widget.volunteers[i];
                          final isSelected = _selected.contains(v.id);
                          return GestureDetector(
                            onTap: () => _toggle(v.id),
                            child: VolunteerPickerRow(
                              volunteer: v,
                              isSelected: isSelected,
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppWidth.s16,
                  AppHeight.s8,
                  AppWidth.s16,
                  AppHeight.s16 + MediaQuery.of(context).padding.bottom,
                ),
                child: PrimaryElevatedButton(
                  title: _selected.isEmpty
                      ? 'تأكيد'
                      : 'تأكيد (${_selected.length})',
                  onPress: () {
                    widget.onConfirm(Set.from(_selected));
                    Navigator.pop(context);
                  },
                  backGroundColor: _selected.isEmpty
                      ? ColorManager.natural300
                      : ColorManager.primary500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
