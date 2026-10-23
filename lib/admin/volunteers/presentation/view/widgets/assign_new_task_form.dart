import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart'
    show campaignTypes;
import 'package:t3afy/admin/campaigns/presentation/view/widgets/dropdown_field.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/core/utils/date_ar.dart';

/// Creates a one-off task and assigns it to this volunteer.
class AssignNewTaskForm extends StatefulWidget {
  const AssignNewTaskForm({super.key});

  @override
  State<AssignNewTaskForm> createState() => _AssignNewTaskFormState();
}

class _AssignNewTaskFormState extends State<AssignNewTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _locationAddressCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeStartCtrl = TextEditingController();
  final _timeEndCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController(text: '10');
  final _supervisorNameCtrl = TextEditingController();
  final _supervisorPhoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _selectedType = campaignTypes.first;
  late DateTime _selectedDate;
  TimeOfDay _timeStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _timeEnd = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _dateCtrl.text = DateAr.date(_selectedDate);
    _timeStartCtrl.text = DateAr.timeOfDay(_hhmm(_timeStart));
    _timeEndCtrl.text = DateAr.timeOfDay(_hhmm(_timeEnd));
  }

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descriptionCtrl,
      _locationCtrl,
      _locationAddressCtrl,
      _dateCtrl,
      _timeStartCtrl,
      _timeEndCtrl,
      _pointsCtrl,
      _supervisorNameCtrl,
      _supervisorPhoneCtrl,
      _notesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Wire format sent to the backend ("HH:mm").
  String _hhmm(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String? _orNull(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = DateAr.date(picked);
      });
    }
  }

  Future<void> _pickTime({required bool start}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: start ? _timeStart : _timeEnd,
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _timeStart = picked;
        _timeStartCtrl.text = DateAr.timeOfDay(_hhmm(picked));
      } else {
        _timeEnd = picked;
        _timeEndCtrl.text = DateAr.timeOfDay(_hhmm(picked));
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final d = _selectedDate;
    final dateStr =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    context.read<VolunteerDetailsCubit>().assignCustomTask(
      adminId: LocalAppStorage.getUserId() ?? '',
      title: _titleCtrl.text.trim(),
      type: _selectedType,
      description: _orNull(_descriptionCtrl),
      locationName: _locationCtrl.text.trim(),
      locationAddress: _orNull(_locationAddressCtrl),
      date: dateStr,
      timeStart: _hhmm(_timeStart),
      timeEnd: _hhmm(_timeEnd),
      durationHours: 0.0, // calculated in datasource from timeStart/timeEnd
      points: int.tryParse(_pointsCtrl.text.trim()) ?? 10,
      supervisorName: _orNull(_supervisorNameCtrl),
      supervisorPhone: _orNull(_supervisorPhoneCtrl),
      notes: _orNull(_notesCtrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Space.vm);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryTextFF(
              label: 'عنوان المهمة',
              hint: 'أدخل عنوان المهمة',
              controller: _titleCtrl,
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            gap,
            DropdownField(
              label: 'نوع المهمة',
              value: _selectedType,
              items: campaignTypes,
              onChanged: (v) =>
                  setState(() => _selectedType = v ?? _selectedType),
            ),
            gap,
            PrimaryTextFF(
              label: 'وصف المهمة (اختياري)',
              hint: 'تفاصيل قصيرة عن المهمة',
              controller: _descriptionCtrl,
              maxLines: 2,
            ),
            gap,
            PrimaryTextFF(
              label: 'اسم الموقع',
              hint: 'مثال: مستشفى الدمرداش',
              controller: _locationCtrl,
              iconData: AppIcons.location,
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            gap,
            PrimaryTextFF(
              label: 'العنوان التفصيلي (اختياري)',
              hint: 'الشارع، الحي',
              controller: _locationAddressCtrl,
              textInputAction: TextInputAction.next,
            ),
            gap,
            PrimaryTextFF(
              label: 'التاريخ',
              hint: 'اختر التاريخ',
              controller: _dateCtrl,
              readOnly: true,
              onTap: _pickDate,
              iconData: AppIcons.calendar,
              validator: _required,
            ),
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PrimaryTextFF(
                    label: 'وقت البداية',
                    hint: 'اختر الوقت',
                    controller: _timeStartCtrl,
                    readOnly: true,
                    onTap: () => _pickTime(start: true),
                    iconData: AppIcons.alarm,
                    validator: _required,
                  ),
                ),
                SizedBox(width: Space.m),
                Expanded(
                  child: PrimaryTextFF(
                    label: 'وقت النهاية',
                    hint: 'اختر الوقت',
                    controller: _timeEndCtrl,
                    readOnly: true,
                    onTap: () => _pickTime(start: false),
                    iconData: AppIcons.alarm,
                    validator: _required,
                  ),
                ),
              ],
            ),
            gap,
            PrimaryTextFF(
              label: 'النقاط',
              hint: '10',
              controller: _pointsCtrl,
              iconData: AppIcons.trophy,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            gap,
            PrimaryTextFF(
              label: 'اسم المشرف (اختياري)',
              hint: 'الاسم',
              controller: _supervisorNameCtrl,
              iconData: AppIcons.mentor,
              textInputAction: TextInputAction.next,
            ),
            gap,
            PrimaryTextFF(
              label: 'هاتف المشرف (اختياري)',
              hint: '01xxxxxxxxx',
              controller: _supervisorPhoneCtrl,
              iconData: AppIcons.phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            gap,
            PrimaryTextFF(
              label: 'ملاحظات (اختياري)',
              hint: 'أي تعليمات إضافية',
              controller: _notesCtrl,
              maxLines: 2,
            ),
            SizedBox(height: Space.vxl),
            BlocSelector<VolunteerDetailsCubit, VolunteerDetailsState, bool>(
              selector: (s) => s is VolunteerDetailsActionLoading,
              builder: (context, isLoading) => PrimaryElevatedButton(
                title: 'تعيين المهمة',
                isLoading: isLoading,
                onPress: _submit,
              ),
            ),
            SizedBox(height: Space.vs),
          ],
        ),
      ),
    );
  }
}
