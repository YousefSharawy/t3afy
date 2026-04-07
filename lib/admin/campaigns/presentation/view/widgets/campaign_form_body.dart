import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'add_item_header.dart';
import 'campaign_form_helpers.dart';
import 'create_volunteer_picker_sheet.dart';
import 'dropdown_field.dart';
import 'form_field_label.dart';
import 'location_picker_view.dart';
import 'objective_field.dart';
import 'supply_field.dart';
import 'volunteer_selection_list.dart';

class CampaignFormBody extends StatelessWidget {
  const CampaignFormBody({
    super.key,
    required this.titleCtrl,
    required this.descCtrl,
    required this.locationNameCtrl,
    required this.locationAddressCtrl,
    required this.supervisorNameCtrl,
    required this.supervisorPhoneCtrl,
    required this.pointsCtrl,
    required this.notesCtrl,
    required this.targetCtrl,
    required this.objectiveCtrls,
    required this.supplyNameCtrls,
    required this.supplyQtyCtrls,
    required this.selectedType,
    required this.isForceCompleted,
    required this.selectedDate,
    required this.timeStart,
    required this.timeEnd,
    required this.volunteers,
    required this.selectedIds,
    required this.onPickDate,
    required this.onPickCombinedTime,
    required this.onAddObjective,
    required this.onRemoveObjective,
    required this.onAddSupply,
    required this.onRemoveSupply,
    required this.selectedPapers,
    required this.onAddPaper,
    required this.onRemovePaper,
    this.selectedLat,
    this.selectedLng,
  });

  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final TextEditingController locationNameCtrl;
  final TextEditingController locationAddressCtrl;
  final TextEditingController supervisorNameCtrl;
  final TextEditingController supervisorPhoneCtrl;
  final TextEditingController pointsCtrl;
  final TextEditingController notesCtrl;
  final TextEditingController targetCtrl;
  final List<TextEditingController> objectiveCtrls;
  final List<TextEditingController> supplyNameCtrls;
  final List<TextEditingController> supplyQtyCtrls;
  final String selectedType;
  final bool isForceCompleted;
  final DateTime? selectedDate;
  final TimeOfDay? timeStart;
  final TimeOfDay? timeEnd;
  final List<VolunteerEntity> volunteers;
  final Set<String> selectedIds;
  final VoidCallback onPickDate;
  final VoidCallback onPickCombinedTime;
  final VoidCallback onAddObjective;
  final void Function(int index) onRemoveObjective;
  final VoidCallback onAddSupply;
  final void Function(int index) onRemoveSupply;
  final List<File> selectedPapers;
  final VoidCallback onAddPaper;
  final void Function(int index) onRemovePaper;
  final double? selectedLat;
  final double? selectedLng;

  @override
  Widget build(BuildContext context) {
    final selectedVolunteers = volunteers
        .where((v) => selectedIds.contains(v.id))
        .toList();

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s18,
        vertical: AppHeight.s16,
      ),
      children: [
        // ── 1. Campaign name ──────────────────────────────────────────────
        const FormFieldLabel('اسم الحملة'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          key: AppTutorialKeys.createCampaignGeneralKey,
          textAlign: .right,
          controller: titleCtrl,
          hint: 'أدخل اسم الحملة',
          validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
        ),
        SizedBox(height: AppHeight.s16),

        // ── 2. Campaign type ──────────────────────────────────────────────
        DropdownField(
          label: 'نوع الحملة',
          value: campaignTypes.contains(selectedType)
              ? selectedType
              : campaignTypes.first,
          items: campaignTypes,
          onChanged: (v) {
            if (v != null) context.read<CreateCampaignCubit>().setType(v);
          },
        ),
        SizedBox(height: AppHeight.s16),

        // ── 4. Location ───────────────────────────────────────────────────
        const FormFieldLabel('اسم الموقع'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          textAlign: .right,
          controller: locationNameCtrl,
          hint: 'أدخل اسم الموقع',
        ),
        SizedBox(height: AppHeight.s8),
        const FormFieldLabel('عنوان الموقع'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          textAlign: .right,
          controller: locationAddressCtrl,
          hint: 'أدخل عنوان الموقع',
        ),
        SizedBox(height: AppHeight.s8),
        // Map picker button / mini preview
        Container(
          key: AppTutorialKeys.createCampaignLocationKey,
          child: _LocationPickerSection(
            selectedLat: selectedLat,
            selectedLng: selectedLng,
          ),
        ),
        SizedBox(height: AppHeight.s8),

        // ── 3. Date ───────────────────────────────────────────────────────
        const FormFieldLabel('التاريخ'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          key: AppTutorialKeys.createCampaignDateKey,
          textAlign: .right,
          controller: TextEditingController(
            text: selectedDate != null ? formatArabicDate(selectedDate!) : '',
          ),
          hint: 'اختر التاريخ',
          readOnly: true,
          onTap: onPickDate,
        ),
        SizedBox(height: AppHeight.s8),

        // ── 4. Time (combined) ────────────────────────────────────────────
        const FormFieldLabel('الوقت'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          textAlign: .right,
          controller: TextEditingController(
            text: (timeStart != null || timeEnd != null)
                ? combinedTimeLabel(timeStart, timeEnd)
                : '',
          ),
          hint: 'اختر الوقت',
          readOnly: true,
          onTap: onPickCombinedTime,
        ),
        SizedBox(height: AppHeight.s8),

        // ── 5. Target beneficiaries ───────────────────────────────────────
        const FormFieldLabel('العدد المستهدف'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          textAlign: .right,
          controller: targetCtrl,
          hint: '0',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppHeight.s8),

        // ── 6. Objectives ─────────────────────────────────────────────────
        AddItemHeader(label: 'الأهداف', onAdd: onAddObjective),
        SizedBox(height: AppHeight.s8),
        ...objectiveCtrls.asMap().entries.map(
          (e) => ObjectiveField(
            index: e.key,
            controller: e.value,
            onRemove: () => onRemoveObjective(e.key),
          ),
        ),
        SizedBox(height: AppHeight.s8),

        // ── 7. Supplies ───────────────────────────────────────────────────
        AddItemHeader(label: 'المستلزمات', onAdd: onAddSupply),
        SizedBox(height: AppHeight.s8),
        ...supplyNameCtrls.asMap().entries.map(
          (e) => SupplyField(
            index: e.key,
            nameController: e.value,
            quantityController: supplyQtyCtrls[e.key],
            onRemove: () => onRemoveSupply(e.key),
          ),
        ),
        SizedBox(height: AppHeight.s8),

        // ── 7b. Permission papers ─────────────────────────────────────────
        Container(
          key: AppTutorialKeys.createCampaignPapersKey,
          child: AddItemHeader(label: 'أوراق التصاريح', onAdd: onAddPaper),
        ),
        SizedBox(height: AppHeight.s8),
        if (selectedPapers.isNotEmpty)
          SizedBox(
            height: 110.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedPapers.length,
              itemBuilder: (context, index) {
                final file = selectedPapers[index];
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: AppWidth.s8),
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: ColorManager.natural100,
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.s12),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.insert_drive_file_outlined,
                              size: 40.r,
                              color: ColorManager.natural400,
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        top: 4,
                        end: 4,
                        child: GestureDetector(
                          onTap: () => onRemovePaper(index),
                          child: Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: BoxDecoration(
                              color: ColorManager.natural900.withValues(
                                alpha: 0.6,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 14.r,
                              color: ColorManager.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        else
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(AppRadius.s12),
              color: ColorManager.natural300,
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60.h,
              child: Center(
                child: Text(
                  'لم يتم إضافة أوراق بعد',
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.natural400,
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: AppHeight.s8),

        // ── 8. Description ────────────────────────────────────────────────
        const FormFieldLabel('وصف الحملة'),
        SizedBox(height: AppHeight.s8),
        PrimaryTextFF(
          textAlign: .right,
          controller: descCtrl,
          hint: 'أدخل وصف الحملة',
          maxLines: 5,
        ),
        SizedBox(height: AppHeight.s8),

        // ── 9. Force-completed toggle ─────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: isForceCompleted
                ? ColorManager.primary500.withValues(alpha: 0.06)
                : ColorManager.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            border: Border.all(
              color: isForceCompleted
                  ? ColorManager.primary500
                  : ColorManager.natural200,
              width: 1,
            ),
          ),
          padding: EdgeInsetsDirectional.fromSTEB(
            AppWidth.s14,
            AppHeight.s12,
            AppWidth.s8,
            AppHeight.s12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'احتساب الحملة كمكتملة مباشرة',
                      style: TextStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        fontWeight: FontWeightManager.semiBold,
                        color: isForceCompleted
                            ? ColorManager.primary500
                            : ColorManager.natural900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isForceCompleted
                          ? 'سيتم احتساب النقاط للمتطوعين المعينين فوراً'
                          : 'سيتم احتساب النقاط والساعات للمتطوعين فوراً',
                      style: TextStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s11,
                        color: isForceCompleted
                            ? ColorManager.primary500
                            : ColorManager.natural400,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isForceCompleted,
                onChanged: (v) =>
                    context.read<CreateCampaignCubit>().setForceCompleted(v),
                activeThumbColor: ColorManager.primary500,
                activeTrackColor: ColorManager.primary500.withValues(
                  alpha: 0.25,
                ),
                inactiveThumbColor: ColorManager.natural400,
                inactiveTrackColor: ColorManager.natural200,
              ),
            ],
          ),
        ),
        SizedBox(height: AppHeight.s8),

        // ── 10. Volunteers ────────────────────────────────────────────────
        const FormFieldLabel('المتطوعون'),
        SizedBox(height: AppHeight.s8),
        Container(
          key: AppTutorialKeys.createCampaignVolunteersKey,
          child: VolunteerSelectionList(
            volunteers: volunteers,
            selectedIds: selectedIds,
            onToggle: (id) =>
                context.read<CreateCampaignCubit>().toggleVolunteer(id),
            onAddPressed: () => _showVolunteerPicker(context),
            selectedVolunteers: selectedVolunteers,
          ),
        ),
        SizedBox(height: AppHeight.s100),
      ],
    );
  }

  void _showVolunteerPicker(BuildContext context) {
    final cubit = context.read<CreateCampaignCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateVolunteerPickerSheet(
        volunteers: volunteers,
        alreadySelected: selectedIds,
        onConfirm: cubit.addVolunteers,
      ),
    );
  }
}

// ── Location picker section ────────────────────────────────────────────────────

class _LocationPickerSection extends StatelessWidget {
  const _LocationPickerSection({this.selectedLat, this.selectedLng});

  final double? selectedLat;
  final double? selectedLng;

  bool get _hasLocation =>
      selectedLat != null &&
      selectedLng != null &&
      selectedLat != 0 &&
      selectedLng != 0;

  Future<void> _openPicker(BuildContext context) async {
    final cubit = context.read<CreateCampaignCubit>();
    final initial = _hasLocation ? LatLng(selectedLat!, selectedLng!) : null;
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => LocationPickerView(initialLocation: initial),
      ),
    );
    if (result != null) {
      cubit.setLocation(result.latitude, result.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasLocation) {
      final point = LatLng(selectedLat!, selectedLng!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini static map preview
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s12),
            child: SizedBox(
              height: 150.h,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 14,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.t3afy.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 36.r,
                        height: 36.r,
                        child: Icon(
                          Icons.location_pin,
                          color: ColorManager.primary500,
                          size: 36.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppHeight.s6),
          Text(
            'خط العرض: ${selectedLat!.toStringAsFixed(4)} — خط الطول: ${selectedLng!.toStringAsFixed(4)}',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural500,
            ),
          ),
          SizedBox(height: AppHeight.s8),
          OutlinedButton.icon(
            onPressed: () => _openPicker(context),
            icon: const Icon(Icons.edit_location_alt_outlined),
            label: const Text('تغيير الموقع على الخريطة'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorManager.primary500,
              side: BorderSide(color: ColorManager.primary500),
              minimumSize: Size(double.infinity, AppHeight.s44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
            ),
          ),
        ],
      );
    }

    // No location selected yet — show picker button
    return OutlinedButton.icon(
      onPressed: () => _openPicker(context),
      icon: const Icon(Icons.add_location_alt_outlined),
      label: const Text('📍 تحديد الموقع على الخريطة'),
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManager.primary500,
        side: BorderSide(color: ColorManager.primary500),
        minimumSize: Size(double.infinity, AppHeight.s44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
      ),
    );
  }
}
