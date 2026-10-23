import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/app_map_preview.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'add_item_header.dart';
import 'dropdown_field.dart';
import 'form_field_label.dart';
import 'location_picker_view.dart';
import 'objective_field.dart';
import 'supply_field.dart';
import 'volunteer_picker_sheet.dart';
import 'volunteer_selection_list.dart';

/// The campaign form, grouped into cards in the order a manager thinks:
/// basics → when → where → team → details → status.
///
/// Cubit-owned values (type, date, time, location, team, force-complete) are
/// read per section with [BlocSelector], so a change to one field rebuilds only
/// its card. Text fields are plain controllers owned by the view.
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
    required this.onPickDate,
    required this.onPickCombinedTime,
    required this.onAddObjective,
    required this.onRemoveObjective,
    required this.onAddSupply,
    required this.onRemoveSupply,
    required this.selectedPapers,
    required this.onAddPaper,
    required this.onRemovePaper,
    this.bottomPadding = 0,
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
  final VoidCallback onPickDate;
  final VoidCallback onPickCombinedTime;
  final VoidCallback onAddObjective;
  final void Function(int index) onRemoveObjective;
  final VoidCallback onAddSupply;
  final void Function(int index) onRemoveSupply;
  final List<File> selectedPapers;
  final VoidCallback onAddPaper;
  final void Function(int index) onRemovePaper;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Space.vl);
    final fieldGap = SizedBox(height: Space.vm);
    final labelGap = SizedBox(height: Space.vs);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        Space.gutter,
        Space.vs,
        Space.gutter,
        Space.vxl + bottomPadding,
      ),
      children: [
        // ── Basics ─────────────────────────────────────────────────────
        _FormCard(
          key: AppTutorialKeys.createCampaignGeneralKey,
          title: 'بيانات الحملة',
          icon: AppIcons.campaigns,
          children: [
            const FormFieldLabel('اسم الحملة'),
            labelGap,
            PrimaryTextFF(
              controller: titleCtrl,
              hint: 'أدخل اسم الحملة',
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'اسم الحملة مطلوب' : null,
            ),
            fieldGap,
            _Select<String>(
              select: (f) => f.selectedType,
              fallback: campaignTypes.first,
              builder: (context, type) => DropdownField(
                label: 'نوع الحملة',
                value: campaignTypes.contains(type) ? type : campaignTypes.first,
                items: campaignTypes,
                onChanged: (v) {
                  if (v != null) context.read<CreateCampaignCubit>().setType(v);
                },
              ),
            ),
            fieldGap,
            const FormFieldLabel('وصف الحملة'),
            labelGap,
            PrimaryTextFF(
              controller: descCtrl,
              hint: 'ما الذي ستقدمه هذه الحملة؟',
              maxLines: 4,
            ),
          ],
        ),
        gap,

        // ── When ───────────────────────────────────────────────────────
        _FormCard(
          key: AppTutorialKeys.createCampaignDateKey,
          title: 'الموعد',
          icon: AppIcons.calendar,
          children: [
            const FormFieldLabel('التاريخ'),
            labelGap,
            _Select<DateTime?>(
              select: (f) => f.selectedDate,
              fallback: null,
              builder: (context, date) => _PickerField(
                icon: AppIcons.calendar,
                hint: 'اختر التاريخ',
                value: date == null ? null : DateAr.weekdayDate(date),
                onTap: onPickDate,
              ),
            ),
            fieldGap,
            const FormFieldLabel('الوقت'),
            labelGap,
            _Select<(TimeOfDay?, TimeOfDay?)>(
              select: (f) => (f.timeStart, f.timeEnd),
              fallback: (null, null),
              builder: (context, t) => _PickerField(
                icon: AppIcons.alarm,
                hint: 'من – إلى',
                value: t.$1 == null && t.$2 == null
                    ? null
                    : DateAr.timeRange(
                        t.$1 == null ? null : CreateCampaignCubit.formatTime(t.$1!),
                        t.$2 == null ? null : CreateCampaignCubit.formatTime(t.$2!),
                      ),
                onTap: onPickCombinedTime,
              ),
            ),
          ],
        ),
        gap,

        // ── Where ──────────────────────────────────────────────────────
        _FormCard(
          title: 'المكان',
          icon: AppIcons.location,
          children: [
            const FormFieldLabel('اسم الموقع'),
            labelGap,
            PrimaryTextFF(
              controller: locationNameCtrl,
              hint: 'مثال: مدرسة النور',
              textInputAction: TextInputAction.next,
            ),
            fieldGap,
            const FormFieldLabel('العنوان'),
            labelGap,
            PrimaryTextFF(
              controller: locationAddressCtrl,
              hint: 'الحي، الشارع',
            ),
            fieldGap,
            Container(
              key: AppTutorialKeys.createCampaignLocationKey,
              child: const _LocationPickerSection(),
            ),
          ],
        ),
        gap,

        // ── Team ───────────────────────────────────────────────────────
        _FormCard(
          key: AppTutorialKeys.createCampaignVolunteersKey,
          title: 'الفريق',
          icon: AppIcons.group,
          children: [
            const FormFieldLabel('المتطوعون'),
            labelGap,
            const _VolunteersSection(),
            fieldGap,
            const FormFieldLabel('اسم المشرف'),
            labelGap,
            PrimaryTextFF(
              controller: supervisorNameCtrl,
              hint: 'اسم مشرف الحملة في الموقع',
              textInputAction: TextInputAction.next,
            ),
            fieldGap,
            const FormFieldLabel('هاتف المشرف'),
            labelGap,
            PrimaryTextFF(
              controller: supervisorPhoneCtrl,
              hint: '01xxxxxxxxx',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        gap,

        // ── Details ────────────────────────────────────────────────────
        _FormCard(
          title: 'التفاصيل',
          icon: AppIcons.details,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormFieldLabel('العدد المستهدف'),
                      labelGap,
                      PrimaryTextFF(
                        controller: targetCtrl,
                        hint: '0',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Space.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormFieldLabel('النقاط'),
                      labelGap,
                      PrimaryTextFF(
                        controller: pointsCtrl,
                        hint: '10',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            fieldGap,
            AddItemHeader(label: 'الأهداف', onAdd: onAddObjective),
            for (final e in objectiveCtrls.asMap().entries)
              ObjectiveField(
                key: ObjectKey(e.value),
                index: e.key,
                controller: e.value,
                onRemove: () => onRemoveObjective(e.key),
              ),
            AddItemHeader(label: 'المستلزمات', onAdd: onAddSupply),
            for (final e in supplyNameCtrls.asMap().entries)
              SupplyField(
                key: ObjectKey(e.value),
                index: e.key,
                nameController: e.value,
                quantityController: supplyQtyCtrls[e.key],
                onRemove: () => onRemoveSupply(e.key),
              ),
            Container(
              key: AppTutorialKeys.createCampaignPapersKey,
              child: AddItemHeader(label: 'أوراق التصاريح', onAdd: onAddPaper),
            ),
            _PapersPreview(papers: selectedPapers, onRemove: onRemovePaper),
            fieldGap,
            const FormFieldLabel('ملاحظات'),
            labelGap,
            PrimaryTextFF(
              controller: notesCtrl,
              hint: 'أي تعليمات إضافية للفريق',
              maxLines: 3,
            ),
          ],
        ),
        gap,

        // ── Status ─────────────────────────────────────────────────────
        const _ForceCompleteCard(),
      ],
    );
  }
}

/// Rebuilds [builder] only when the selected form value changes.
class _Select<T> extends StatelessWidget {
  const _Select({
    super.key,
    required this.select,
    required this.fallback,
    required this.builder,
  });

  final T Function(CreateCampaignReady form) select;
  final T fallback;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateCampaignCubit>();
    return BlocSelector<CreateCampaignCubit, CreateCampaignState, T>(
      selector: (_) {
        final form = cubit.form;
        return form == null ? fallback : select(form);
      },
      builder: builder,
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge(icon: icon, size: 32),
              SizedBox(width: Space.s),
              Text(title, style: AppText.title()),
            ],
          ),
          SizedBox(height: Space.vl),
          ...children,
        ],
      ),
    );
  }
}

/// Read-only field that opens a picker (date / time).
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.icon,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String hint;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(Radii.input);
    return Semantics(
      button: true,
      label: value ?? hint,
      child: Material(
        color: ColorManager.surfaceSunken,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: AppSizes.touch),
            padding: EdgeInsets.symmetric(horizontal: Space.m),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: ColorManager.line),
            ),
            child: Row(
              children: [
                Icon(icon, size: AppSizes.iconM, color: ColorManager.inkMuted),
                SizedBox(width: Space.s),
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: value == null
                        ? getRegularStyle(
                            fontSize: FontSize.s15,
                            color: ColorManager.inkFaint,
                          )
                        : getNumericStyle(
                            fontSize: FontSize.s15,
                            color: ColorManager.ink,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VolunteersSection extends StatelessWidget {
  const _VolunteersSection();

  Future<void> _openPicker(BuildContext context) {
    final cubit = context.read<CreateCampaignCubit>();
    final form = cubit.form;
    return VolunteerPickerSheet.show(
      context,
      volunteers: form?.volunteers ?? const [],
      initialSelected: form?.selectedIds ?? const {},
      confirmLabel: 'تأكيد',
      onRefresh: () async {
        await cubit.refreshVolunteers();
        return cubit.form?.volunteers ?? const <VolunteerEntity>[];
      },
      onConfirm: (ids) async {
        cubit.setVolunteers(ids);
        return true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Select<(List<VolunteerEntity>, Set<String>)>(
      select: (f) => (f.volunteers, f.selectedIds),
      fallback: (const [], const {}),
      builder: (context, v) => VolunteerSelectionList(
        selectedVolunteers: v.$1.where((x) => v.$2.contains(x.id)).toList(),
        onRemove: context.read<CreateCampaignCubit>().toggleVolunteer,
        onAddPressed: () => _openPicker(context),
      ),
    );
  }
}

class _LocationPickerSection extends StatelessWidget {
  const _LocationPickerSection();

  Future<void> _openPicker(BuildContext context, LatLng? initial) async {
    final cubit = context.read<CreateCampaignCubit>();
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => LocationPickerView(initialLocation: initial),
      ),
    );
    if (result != null) cubit.setLocation(result.latitude, result.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return _Select<(double?, double?)>(
      select: (f) => (f.locationLat, f.locationLng),
      fallback: (null, null),
      builder: (context, loc) {
        final has =
            loc.$1 != null && loc.$2 != null && loc.$1 != 0 && loc.$2 != 0;
        final point = has ? LatLng(loc.$1!, loc.$2!) : null;
        final button = OutlinedButton.icon(
          onPressed: () => _openPicker(context, point),
          icon: Icon(
            has ? Icons.edit_location_alt_rounded : Icons.add_location_alt_rounded,
            size: 20,
          ),
          label: Text(has ? 'تغيير الموقع على الخريطة' : 'تحديد الموقع على الخريطة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorManager.brand,
            side: const BorderSide(color: ColorManager.brand),
            minimumSize: Size(double.infinity, AppSizes.touch),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.input),
            ),
          ),
        );
        if (point == null) return button;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppMapPreview(
              point: point,
              height: 150,
              onTap: () => _openPicker(context, point),
            ),
            SizedBox(height: Space.vs),
            button,
          ],
        );
      },
    );
  }
}

class _PapersPreview extends StatelessWidget {
  const _PapersPreview({required this.papers, required this.onRemove});

  final List<File> papers;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (papers.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: Space.vl),
        decoration: BoxDecoration(
          color: ColorManager.surfaceSunken,
          borderRadius: BorderRadius.circular(Radii.input),
          border: Border.all(color: ColorManager.line),
        ),
        child: Text(
          'لم تتم إضافة أوراق بعد',
          style: AppText.label(color: ColorManager.inkFaint),
          textAlign: TextAlign.center,
        ),
      );
    }
    const size = 96.0;
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: papers.length,
        separatorBuilder: (_, _) => SizedBox(width: Space.s),
        itemBuilder: (context, index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.input),
              child: Container(
                width: size,
                height: size,
                color: ColorManager.surfaceSunken,
                child: Image.file(
                  papers[index],
                  fit: BoxFit.cover,
                  cacheWidth: (size * 2).round(),
                  errorBuilder: (_, _, _) => const Icon(
                    AppIcons.details,
                    color: ColorManager.inkFaint,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 0,
              child: IconButton(
                tooltip: 'إزالة',
                onPressed: () => onRemove(index),
                style: IconButton.styleFrom(
                  backgroundColor: ColorManager.scrim,
                  foregroundColor: ColorManager.white,
                ),
                iconSize: 16,
                icon: const Icon(AppIcons.x),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForceCompleteCard extends StatelessWidget {
  const _ForceCompleteCard();

  @override
  Widget build(BuildContext context) {
    return _Select<bool>(
      select: (f) => f.isForceCompleted,
      fallback: false,
      builder: (context, on) => AppCard(
        border: Border.all(color: on ? ColorManager.brand : ColorManager.transparent),
        onTap: () => context.read<CreateCampaignCubit>().setForceCompleted(!on),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('احتساب الحملة كمكتملة الآن', style: AppText.bodyStrong()),
                  SizedBox(height: Space.vxs * 0.5),
                  Text(
                    on
                        ? 'ستُحتسب النقاط والساعات للمتطوعين المعيّنين فور الحفظ'
                        : 'تُحدَّد حالة الحملة تلقائياً حسب التاريخ والوقت',
                    style: AppText.label(
                      color: on ? ColorManager.brandStrong : ColorManager.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: on,
              onChanged: context.read<CreateCampaignCubit>().setForceCompleted,
              activeThumbColor: ColorManager.brand,
              activeTrackColor: ColorManager.brandSoft,
            ),
          ],
        ),
      ),
    );
  }
}
