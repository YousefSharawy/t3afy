import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/base/widgets/app_form_field.dart';
import 'package:t3afy/base/widgets/readonly_field.dart';
import 'package:t3afy/base/widgets/section_label.dart';
import 'widgets/add_item_header.dart';
import 'widgets/dropdown_field.dart';
import 'widgets/objective_field.dart';
import 'widgets/supply_field.dart';
import 'widgets/volunteer_selection_list.dart';

class CreateCampaignView extends StatefulWidget {
  const CreateCampaignView({super.key, this.taskId});

  final String? taskId;

  bool get isEditing => taskId != null;

  @override
  State<CreateCampaignView> createState() => _CreateCampaignViewState();
}

class _CreateCampaignViewState extends State<CreateCampaignView> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationNameCtrl = TextEditingController();
  final _locationAddressCtrl = TextEditingController();
  final _supervisorNameCtrl = TextEditingController();
  final _supervisorPhoneCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();
  final _targetCtrl = TextEditingController(text: '0');

  String _selectedType = 'توعية مدرسية';
  String _selectedStatus = 'upcoming';
  DateTime? _selectedDate;
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;

  final List<TextEditingController> _objectiveCtrls = [];
  final List<TextEditingController> _supplyNameCtrls = [];
  final List<TextEditingController> _supplyQtyCtrls = [];

  bool _prefilled = false;

  static const _types = ['توعية مدرسية', 'توعية جامعية', 'زيارة ميدانية'];
  static const _statuses = ['upcoming', 'active', 'done'];
  static const _statusLabels = {
    'upcoming': 'قادمة',
    'active': 'جارية',
    'done': 'مكتملة',
  };

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CreateCampaignCubit>();
    if (widget.isEditing) {
      cubit.loadForEdit(widget.taskId!);
    } else {
      cubit.loadVolunteers();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationNameCtrl.dispose();
    _locationAddressCtrl.dispose();
    _supervisorNameCtrl.dispose();
    _supervisorPhoneCtrl.dispose();
    _pointsCtrl.dispose();
    _notesCtrl.dispose();
    _targetCtrl.dispose();
    for (final c in _objectiveCtrls) {
      c.dispose();
    }
    for (final c in _supplyNameCtrls) {
      c.dispose();
    }
    for (final c in _supplyQtyCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _prefillControllers(Map<String, dynamic> data) {
    setState(() {
      _titleCtrl.text = data['title'] as String? ?? '';
      _descCtrl.text = data['description'] as String? ?? '';
      _locationNameCtrl.text = data['location_name'] as String? ?? '';
      _locationAddressCtrl.text = data['location_address'] as String? ?? '';
      _supervisorNameCtrl.text = data['supervisor_name'] as String? ?? '';
      _supervisorPhoneCtrl.text = data['supervisor_phone'] as String? ?? '';
      _pointsCtrl.text = '${data['points'] ?? 0}';
      _notesCtrl.text = data['notes'] as String? ?? '';
      _targetCtrl.text = '${data['target_beneficiaries'] ?? 0}';
      _selectedType = data['type'] as String? ?? 'توعية مدرسية';
      _selectedStatus = data['status'] as String? ?? 'upcoming';

      final dateStr = data['date'] as String?;
      if (dateStr != null) _selectedDate = DateTime.tryParse(dateStr);

      final timeStartStr = data['time_start'] as String?;
      if (timeStartStr != null) {
        final parts = timeStartStr.split(':');
        if (parts.length >= 2) {
          _timeStart = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }

      final timeEndStr = data['time_end'] as String?;
      if (timeEndStr != null) {
        final parts = timeEndStr.split(':');
        if (parts.length >= 2) {
          _timeEnd = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }

      for (final c in _objectiveCtrls) {
        c.dispose();
      }
      _objectiveCtrls.clear();
      final objectives = data['objectives'] as List<dynamic>? ?? [];
      for (final o in objectives) {
        _objectiveCtrls.add(TextEditingController(text: o as String? ?? ''));
      }

      for (final c in _supplyNameCtrls) {
        c.dispose();
      }
      for (final c in _supplyQtyCtrls) {
        c.dispose();
      }
      _supplyNameCtrls.clear();
      _supplyQtyCtrls.clear();
      final supplies = data['supplies'] as List<dynamic>? ?? [];
      for (final s in supplies) {
        final map = s as Map<String, dynamic>;
        _supplyNameCtrls.add(
          TextEditingController(text: map['name'] as String? ?? ''),
        );
        _supplyQtyCtrls.add(
          TextEditingController(text: '${map['quantity'] ?? 1}'),
        );
      }
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: ColorManager.cyanPrimary),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_timeStart ?? TimeOfDay.now())
          : (_timeEnd ?? TimeOfDay.now()),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: ColorManager.cyanPrimary),
        ),
        child: child!,
      ),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _timeStart = time;
        } else {
          _timeEnd = time;
        }
      });
    }
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showSnack('يرجى اختيار تاريخ الحملة');
      return;
    }
    if (_timeStart == null || _timeEnd == null) {
      _showSnack('يجب تحديد وقت البداية والنهاية');
      return;
    }

    final adminId = LocalAppStorage.getUserId() ?? '';
    final formData = <String, dynamic>{
      'title': _titleCtrl.text.trim(),
      'type': _selectedType,
      'description': _descCtrl.text.trim().isEmpty
          ? null
          : _descCtrl.text.trim(),
      'status': _selectedStatus,
      'date': _selectedDate!.toIso8601String().split('T')[0],
      'time_start': _formatTime(_timeStart!),
      'time_end': _formatTime(_timeEnd!),
      'location_name': _locationNameCtrl.text.trim().isEmpty
          ? null
          : _locationNameCtrl.text.trim(),
      'location_address': _locationAddressCtrl.text.trim().isEmpty
          ? null
          : _locationAddressCtrl.text.trim(),
      'supervisor_name': _supervisorNameCtrl.text.trim().isEmpty
          ? null
          : _supervisorNameCtrl.text.trim(),
      'supervisor_phone': _supervisorPhoneCtrl.text.trim().isEmpty
          ? null
          : _supervisorPhoneCtrl.text.trim(),
      'points': int.tryParse(_pointsCtrl.text) ?? 0,
      'notes': _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      'target_beneficiaries': int.tryParse(_targetCtrl.text) ?? 0,
      'objective_titles': _objectiveCtrls
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      'supplies_data': List.generate(_supplyNameCtrls.length, (i) {
        final name = _supplyNameCtrls[i].text.trim();
        final qty = int.tryParse(_supplyQtyCtrls[i].text) ?? 1;
        return {'name': name, 'quantity': qty};
      }).where((s) => (s['name'] as String).isNotEmpty).toList(),
    };
    if (!widget.isEditing) {
      formData['created_by'] = adminId;
    }
    context.read<CreateCampaignCubit>().save(
      formData: formData,
      taskId: widget.taskId,
    );
  }
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCampaignCubit, CreateCampaignState>(
      listener: (context, state) {
        if (state is CreateCampaignReady &&
            state.taskData != null &&
            !_prefilled) {
          _prefilled = true;
          _prefillControllers(state.taskData!);
        } else if (state is CreateCampaignSaved) {
          _showSnack(
            widget.isEditing
                ? 'تم تحديث الحملة بنجاح'
                : 'تم إنشاء الحملة بنجاح',
          );
          if (mounted) Navigator.of(context).pop(true);
        } else if (state is CreateCampaignActionError) {
          _showSnack(state.message);
        } else if (state is CreateCampaignError) {
          _showSnack(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateCampaignLoading;
        final isSaving = state is CreateCampaignSaving;
        final volunteers = state is CreateCampaignReady
            ? state.volunteers
            : <VolunteerEntity>[];
        final selectedIds = state is CreateCampaignReady
            ? state.selectedIds
            : const <String>{};
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            appBar: AppBar(
              backgroundColor: ColorManager.background,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorManager.blueOne900,
                  size: 20.r,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                widget.isEditing ? 'تعديل الحملة' : 'حملة جديدة',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s16,
                  color: ColorManager.blueOne900,
                ),
              ),
              centerTitle: true,
              actions: [
                if (isSaving)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.s16),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: ColorManager.cyanPrimary,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                else
                  TextButton(
                    onPressed: _save,
                    child: Text(
                      'حفظ',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: ColorManager.cyanPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: ColorManager.cyanPrimary),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(AppSize.s16),
                      children: [
                        SectionLabel(label:'معلومات الحملة'),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _titleCtrl,
                          hint: 'عنوان الحملة',
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.camp, width: 18, height: 18),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'مطلوب' : null,
                        ),
                        SizedBox(height: AppHeight.s10),
                        DropdownField(
                          label: 'النوع',
                          value: _selectedType,
                          items: _types,
                          onChanged: (v) => setState(() => _selectedType = v!),
                        ),
                        SizedBox(height: AppHeight.s10),
                        DropdownField(
                          label: 'الحالة',
                          value: _selectedStatus,
                          items: _statuses,
                          itemLabel: (v) => _statusLabels[v] ?? v,
                          onChanged: (v) =>
                              setState(() => _selectedStatus = v!),
                        ),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _descCtrl,
                          hint: 'الوصف',
                          maxLines: 3,
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.edit, width: 18, height: 18),
                        ),
                        SizedBox(height: AppHeight.s20),
                        SectionLabel(label:'التوقيت والموقع'),
                        SizedBox(height: AppHeight.s10),
                        GestureDetector(
                          onTap: _pickDate,
                          child: ReadonlyField(
                            value: _selectedDate != null
                                ? _selectedDate!.toIso8601String().split('T')[0]
                                : 'اختر تاريخ الحملة',
                            icon: Icons.calendar_today_outlined,
                            backgroundColor: ColorManager.blueOne700,
                            borderColor: ColorManager.blueOne600,
                            textColor: ColorManager.white,
                            iconColor: ColorManager.cyanPrimary,
                          ),
                        ),
                        SizedBox(height: AppHeight.s10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickTime(true),
                                child: ReadonlyField(
                                  value: _timeStart != null
                                      ? _formatTime(_timeStart!)
                                      : 'وقت البدء',
                                  icon: Icons.schedule_outlined,
                                  backgroundColor: ColorManager.blueOne700,
                                  borderColor: ColorManager.blueOne600,
                                  textColor: ColorManager.white,
                                  iconColor: ColorManager.cyanPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: AppWidth.s10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickTime(false),
                                child: ReadonlyField(
                                  value: _timeEnd != null
                                      ? _formatTime(_timeEnd!)
                                      : 'وقت الانتهاء',
                                  icon: Icons.schedule_outlined,
                                  backgroundColor: ColorManager.blueOne700,
                                  borderColor: ColorManager.blueOne600,
                                  textColor: ColorManager.white,
                                  iconColor: ColorManager.cyanPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _locationNameCtrl,
                          hint: 'اسم الموقع',
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.location, width: 18, height: 18),
                        ),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _locationAddressCtrl,
                          hint: 'عنوان الموقع التفصيلي',
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.location, width: 18, height: 18),
                        ),
                        SizedBox(height: AppHeight.s20),
                        SectionLabel(label:'المشرف'),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _supervisorNameCtrl,
                          hint: 'اسم المشرف',
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.person, width: 18, height: 18),
                        ),
                        SizedBox(height: AppHeight.s10),
                        AppFormField(
                          controller: _supervisorPhoneCtrl,
                          hint: 'هاتف المشرف',
                          keyboardType: TextInputType.phone,
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.phone, width: 18, height: 18),
                        ),
                        SizedBox(height: AppHeight.s20),
                        SectionLabel(label:'الأهداف والمستلزمات'),
                        SizedBox(height: AppHeight.s10),
                        Row(
                          children: [
                            Expanded(
                              child: AppFormField(
                                controller: _pointsCtrl,
                                hint: 'النقاط',
                                keyboardType: TextInputType.number,
                                fillColor: ColorManager.blueOne700,
                                borderColor: ColorManager.blueOne600,
                                textColor: ColorManager.white,
                                hintColor: ColorManager.blueOne300,
                                prefixIcon: Image.asset(IconAssets.star, width: 18, height: 18),
                              ),
                            ),
                            SizedBox(width: AppWidth.s10),
                            Expanded(
                              child: AppFormField(
                                controller: _targetCtrl,
                                hint: 'المستفيدون المستهدفون',
                                keyboardType: TextInputType.number,
                                fillColor: ColorManager.blueOne700,
                                borderColor: ColorManager.blueOne600,
                                textColor: ColorManager.white,
                                hintColor: ColorManager.blueOne300,
                                prefixIcon: Image.asset(IconAssets.target, width: 18, height: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppHeight.s16),
                        AddItemHeader(
                          label: 'الأهداف',
                          onAdd: () => setState(
                            () => _objectiveCtrls.add(
                              TextEditingController(),
                            ),
                          ),
                        ),
                        SizedBox(height: AppHeight.s8),
                        ..._objectiveCtrls.asMap().entries.map(
                          (e) => ObjectiveField(
                            index: e.key,
                            controller: e.value,
                            onRemove: () => setState(() {
                              e.value.dispose();
                              _objectiveCtrls.removeAt(e.key);
                            }),
                          ),
                        ),
                        SizedBox(height: AppHeight.s16),
                        AddItemHeader(
                          label: 'المستلزمات',
                          onAdd: () => setState(() {
                            _supplyNameCtrls.add(TextEditingController());
                            _supplyQtyCtrls.add(
                              TextEditingController(text: '1'),
                            );
                          }),
                        ),
                        SizedBox(height: AppHeight.s8),
                        ..._supplyNameCtrls.asMap().entries.map(
                          (e) => SupplyField(
                            index: e.key,
                            nameController: e.value,
                            quantityController: _supplyQtyCtrls[e.key],
                            onRemove: () => setState(() {
                              e.value.dispose();
                              _supplyQtyCtrls[e.key].dispose();
                              _supplyNameCtrls.removeAt(e.key);
                              _supplyQtyCtrls.removeAt(e.key);
                            }),
                          ),
                        ),
                        SizedBox(height: AppHeight.s20),
                        SectionLabel(label:'المتطوعون'),
                        SizedBox(height: AppHeight.s10),
                        VolunteerSelectionList(
                          volunteers: volunteers,
                          selectedIds: selectedIds,
                          onToggle: (id) => context
                              .read<CreateCampaignCubit>()
                              .toggleVolunteer(id),
                        ),
                        SizedBox(height: AppHeight.s20),
                        AppFormField(
                          controller: _notesCtrl,
                          hint: 'ملاحظات إضافية',
                          maxLines: 3,
                          fillColor: ColorManager.blueOne700,
                          borderColor: ColorManager.blueOne600,
                          textColor: ColorManager.white,
                          hintColor: ColorManager.blueOne300,
                          prefixIcon: Image.asset(IconAssets.edit, width: 18, height: 18),
                        ),
                        SizedBox(height: AppHeight.s100),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}