import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/campaigns/domain/entities/volunteer_entity.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'widgets/campaign_form_body.dart';

class CreateCampaignView extends StatefulWidget {
  const CreateCampaignView({super.key, this.taskId});

  final String? taskId;
  bool get isEditing => taskId != null;

  @override
  State<CreateCampaignView> createState() => _CreateCampaignViewState();
}

class _CreateCampaignViewState extends State<CreateCampaignView> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationNameCtrl = TextEditingController();
  final _locationAddressCtrl = TextEditingController();
  final _supervisorNameCtrl = TextEditingController();
  final _supervisorPhoneCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();
  final _targetCtrl = TextEditingController(text: '0');

  final List<TextEditingController> _objectiveCtrls = [];
  final List<TextEditingController> _supplyNameCtrls = [];
  final List<TextEditingController> _supplyQtyCtrls = [];

  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CreateCampaignCubit>();
    widget.isEditing
        ? cubit.loadForEdit(widget.taskId!)
        : cubit.loadVolunteers();
  }

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descCtrl,
      _locationNameCtrl,
      _locationAddressCtrl,
      _supervisorNameCtrl,
      _supervisorPhoneCtrl,
      _pointsCtrl,
      _notesCtrl,
      _targetCtrl,
      ..._objectiveCtrls,
      ..._supplyNameCtrls,
      ..._supplyQtyCtrls,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Controller prefill (text assignment only — pure UI) ───────────────────

  void _prefillControllers(Map<String, dynamic> data) {
    _titleCtrl.text = data['title'] as String? ?? '';
    _descCtrl.text = data['description'] as String? ?? '';
    _locationNameCtrl.text = data['location_name'] as String? ?? '';
    _locationAddressCtrl.text = data['location_address'] as String? ?? '';
    _supervisorNameCtrl.text = data['supervisor_name'] as String? ?? '';
    _supervisorPhoneCtrl.text = data['supervisor_phone'] as String? ?? '';
    _pointsCtrl.text = '${data['points'] ?? 0}';
    _notesCtrl.text = data['notes'] as String? ?? '';
    _targetCtrl.text = '${data['target_beneficiaries'] ?? 0}';

    for (final c in _objectiveCtrls) {
      c.dispose();
    }
    _objectiveCtrls
      ..clear()
      ..addAll(
        (data['objectives'] as List<dynamic>? ?? []).map(
          (o) => TextEditingController(text: o as String? ?? ''),
        ),
      );

    for (final c in [..._supplyNameCtrls, ..._supplyQtyCtrls]) {
      c.dispose();
    }
    _supplyNameCtrls.clear();
    _supplyQtyCtrls.clear();
    for (final s in (data['supplies'] as List<dynamic>? ?? [])) {
      final map = s as Map<String, dynamic>;
      _supplyNameCtrls.add(
        TextEditingController(text: map['name'] as String? ?? ''),
      );
      _supplyQtyCtrls.add(
        TextEditingController(text: '${map['quantity'] ?? 1}'),
      );
    }
  }

  // ── Pickers (must stay in view — need BuildContext for dialogs) ───────────

  Future<void> _pickDate() async {
    final cubit = context.read<CreateCampaignCubit>();
    final current = (cubit.state is CreateCampaignReady)
        ? (cubit.state as CreateCampaignReady).selectedDate
        : null;
    final date = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (date != null) cubit.setDate(date);
  }

  Future<void> _pickCombinedTime() async {
    final cubit = context.read<CreateCampaignCubit>();
    final ready = cubit.state is CreateCampaignReady
        ? cubit.state as CreateCampaignReady
        : null;
    final start = await showTimePicker(
      context: context,
      initialTime: ready?.timeStart ?? TimeOfDay.now(),
    );
    if (start == null || !mounted) return;
    cubit.setTimeStart(start);
    final end = await showTimePicker(
      context: context,
      initialTime: ready?.timeEnd ?? start,
    );
    if (end == null) return;
    cubit.setTimeEnd(end);
  }

  // ── Save (assembles text from controllers → delegates to cubit) ───────────

  void _save() {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;
    context.read<CreateCampaignCubit>().save(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      locationName: _locationNameCtrl.text.trim().isEmpty
          ? null
          : _locationNameCtrl.text.trim(),
      locationAddress: _locationAddressCtrl.text.trim().isEmpty
          ? null
          : _locationAddressCtrl.text.trim(),
      supervisorName: _supervisorNameCtrl.text.trim().isEmpty
          ? null
          : _supervisorNameCtrl.text.trim(),
      supervisorPhone: _supervisorPhoneCtrl.text.trim().isEmpty
          ? null
          : _supervisorPhoneCtrl.text.trim(),
      points: int.tryParse(_pointsCtrl.text) ?? 0,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      targetBeneficiaries: int.tryParse(_targetCtrl.text) ?? 0,
      objectiveTitles: _objectiveCtrls
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      suppliesData: List.generate(
        _supplyNameCtrls.length,
        (i) => {
          'name': _supplyNameCtrls[i].text.trim(),
          'quantity': int.tryParse(_supplyQtyCtrls[i].text) ?? 1,
        },
      ).where((s) => (s['name'] as String).isNotEmpty).toList(),
      taskId: widget.taskId,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateCampaignCubit, CreateCampaignState>(
      listener: (context, state) {
        if (state is CreateCampaignReady &&
            state.taskData != null &&
            !_prefilled) {
          _prefilled = true;
          setState(() => _prefillControllers(state.taskData!));
        } else if (state is CreateCampaignSaved) {
          Toast.success.show(
            context,
            title: widget.isEditing ? 'تم تحديث الحملة بنجاح' : 'تم إنشاء الحملة بنجاح',
          );
          if (mounted) Navigator.of(context).pop(true);
        } else if (state is CreateCampaignActionError ||
            state is CreateCampaignValidationError ||
            state is CreateCampaignError) {
          final msg = state is CreateCampaignActionError
              ? state.message
              : state is CreateCampaignValidationError
              ? state.message
              : (state as CreateCampaignError).message;
          Toast.error.show(context, title: msg);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateCampaignLoading;
        final isSaving = state is CreateCampaignSaving;
        final ready = state is CreateCampaignReady ? state : null;

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
                  color: ColorManager.black,
                  size: 24.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Text(
                widget.isEditing ? 'تعديل الحملة' : 'حملة جديدة',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s16,
                  color: ColorManager.natural900,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : _save,
                  child: Text(
                    'حفظ',
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color:  ColorManager.primary500,
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary500,
                    ),
                  )
                else
                  Form(
                    key: _formKey,
                    child: CampaignFormBody(
                      titleCtrl: _titleCtrl,
                      descCtrl: _descCtrl,
                      locationNameCtrl: _locationNameCtrl,
                      locationAddressCtrl: _locationAddressCtrl,
                      supervisorNameCtrl: _supervisorNameCtrl,
                      supervisorPhoneCtrl: _supervisorPhoneCtrl,
                      pointsCtrl: _pointsCtrl,
                      notesCtrl: _notesCtrl,
                      targetCtrl: _targetCtrl,
                      objectiveCtrls: _objectiveCtrls,
                      supplyNameCtrls: _supplyNameCtrls,
                      supplyQtyCtrls: _supplyQtyCtrls,
                      selectedType: ready?.selectedType ?? campaignTypes.first,
                      isForceCompleted: ready?.isForceCompleted ?? false,
                      selectedDate: ready?.selectedDate,
                      timeStart: ready?.timeStart,
                      timeEnd: ready?.timeEnd,
                      volunteers: ready?.volunteers ?? <VolunteerEntity>[],
                      selectedIds: ready?.selectedIds ?? const <String>{},
                      onPickDate: _pickDate,
                      onPickCombinedTime: _pickCombinedTime,
                      onAddObjective: () => setState(
                        () => _objectiveCtrls.add(TextEditingController()),
                      ),
                      onRemoveObjective: (i) => setState(() {
                        _objectiveCtrls[i].dispose();
                        _objectiveCtrls.removeAt(i);
                      }),
                      onAddSupply: () => setState(() {
                        _supplyNameCtrls.add(TextEditingController());
                        _supplyQtyCtrls.add(TextEditingController(text: '1'));
                      }),
                      onRemoveSupply: (i) => setState(() {
                        _supplyNameCtrls[i].dispose();
                        _supplyQtyCtrls[i].dispose();
                        _supplyNameCtrls.removeAt(i);
                        _supplyQtyCtrls.removeAt(i);
                      }),
                    ),
                  ),
                if (isSaving)
                  IgnorePointer(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.primary500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
