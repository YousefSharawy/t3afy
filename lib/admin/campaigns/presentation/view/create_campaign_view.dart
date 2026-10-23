import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_async_body.dart';
import 'package:t3afy/base/widgets/app_page_header.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/services/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
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
  final _pointsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _targetCtrl = TextEditingController(text: '0');

  final List<TextEditingController> _objectiveCtrls = [];
  final List<TextEditingController> _supplyNameCtrls = [];
  final List<TextEditingController> _supplyQtyCtrls = [];
  final List<File> _selectedPapers = [];

  bool _prefilled = false;
  bool _tutorialShown = false;

  final _imagePicker = ImagePicker();

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
    final current = cubit.form?.selectedDate;
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
    final ready = cubit.form;
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

  // ── Papers ────────────────────────────────────────────────────────────────

  Future<void> _pickPapers() async {
    final picked = await _imagePicker.pickMultiImage();
    if (picked.isEmpty) return;
    setState(() {
      for (final xf in picked) {
        _selectedPapers.add(File(xf.path));
      }
    });
  }

  // ── Save (assembles text from controllers → delegates to cubit) ───────────

  void _save() {
    if (!_formKey.currentState!.validate()) {
      Toast.error.show(context, title: 'أكمل الحقول المطلوبة');
      return;
    }
    final cubit = context.read<CreateCampaignCubit>();
    cubit.save(
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
      paperFiles: List.from(_selectedPapers),
      taskId: widget.taskId,
      locationLat: cubit.form?.locationLat,
      locationLng: cubit.form?.locationLng,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  /// Which body to show; the form survives saving/error states.
  static int _phase(CreateCampaignState s) => switch (s) {
    CreateCampaignInitial() || CreateCampaignLoading() => 0,
    CreateCampaignError() => 1,
    _ => 2,
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateCampaignCubit>();
    return BlocListener<CreateCampaignCubit, CreateCampaignState>(
      listener: (context, state) {
        if (state is CreateCampaignReady &&
            !_tutorialShown &&
            !widget.isEditing) {
          if (!LocalAppStorage.isCreateCampaignTutorialCompleted()) {
            _tutorialShown = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _showTutorial(this.context);
            });
          }
        }

        if (state is CreateCampaignReady &&
            state.taskData != null &&
            !_prefilled) {
          _prefilled = true;
          setState(() => _prefillControllers(state.taskData!));
        } else if (state is CreateCampaignSaved) {
          Toast.success.show(
            context,
            title: widget.isEditing
                ? 'تم تحديث الحملة بنجاح'
                : 'تم إنشاء الحملة بنجاح',
          );
          Navigator.of(context).pop(true);
        } else if (state is CreateCampaignActionError) {
          Toast.error.show(context, title: state.message);
        } else if (state is CreateCampaignValidationError) {
          Toast.error.show(context, title: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.canvas,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppPageHeader(
                title: widget.isEditing ? 'تعديل الحملة' : 'حملة جديدة',
                showBack: true,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: BlocBuilder<CreateCampaignCubit, CreateCampaignState>(
                  buildWhen: (prev, curr) => _phase(prev) != _phase(curr),
                  builder: (context, state) {
                    return AppAsyncBody(
                      hasData: _phase(state) == 2,
                      errorMessage: state is CreateCampaignError
                          ? state.message
                          : null,
                      onRetry: () => widget.isEditing
                          ? cubit.loadForEdit(widget.taskId!)
                          : cubit.loadVolunteers(),
                      skeleton: const SkeletonList(count: 3, itemHeight: 220),
                      builder: (context) => Form(
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
                          onPickDate: _pickDate,
                          onPickCombinedTime: _pickCombinedTime,
                          onAddObjective: () => setState(
                            () => _objectiveCtrls.add(TextEditingController()),
                          ),
                          onRemoveObjective: (i) => setState(() {
                            _objectiveCtrls.removeAt(i).dispose();
                          }),
                          onAddSupply: () => setState(() {
                            _supplyNameCtrls.add(TextEditingController());
                            _supplyQtyCtrls.add(TextEditingController(text: '1'));
                          }),
                          onRemoveSupply: (i) => setState(() {
                            _supplyNameCtrls.removeAt(i).dispose();
                            _supplyQtyCtrls.removeAt(i).dispose();
                          }),
                          selectedPapers: _selectedPapers,
                          onAddPaper: _pickPapers,
                          onRemovePaper: (i) =>
                              setState(() => _selectedPapers.removeAt(i)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              BlocSelector<CreateCampaignCubit, CreateCampaignState, (bool, bool)>(
                selector: (s) => (_phase(s) == 2, s is CreateCampaignSaving),
                builder: (context, v) {
                  if (!v.$1) return const SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.fromLTRB(
                      Space.gutter,
                      Space.vm,
                      Space.gutter,
                      Space.vm + MediaQuery.paddingOf(context).bottom,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.surface,
                      boxShadow: AppShadows.card,
                    ),
                    child: PrimaryElevatedButton(
                      title: widget.isEditing ? 'حفظ التغييرات' : 'حفظ الحملة',
                      isLoading: v.$2,
                      onPress: _save,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    TutorialService.createTutorial(
      targets: _createTargets(),
      onFinish: () {
        LocalAppStorage.setCreateCampaignTutorialCompleted(true);
      },
      onSkip: () {
        LocalAppStorage.setCreateCampaignTutorialCompleted(true);
      },
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TutorialService.createTarget(
        identify: "title",
        keyTarget: AppTutorialKeys.createCampaignGeneralKey,
        title: "بيانات الحملة الأساسية",
        description: "أدخل هنا اسم الحملة ونوعها والوصف.",
        contentPosition: 1,
        stepIndex: 1,
        totalSteps: 5,
      ),
      TutorialService.createTarget(
        identify: "location",
        keyTarget: AppTutorialKeys.createCampaignLocationKey,
        title: "تحديد الموقع",
        description: "اختر موقع المهمة بدقة على الخريطة.",
        contentPosition: 0,
        stepIndex: 2,
        totalSteps: 5,
      ),
      TutorialService.createTarget(
        identify: "date",
        keyTarget: AppTutorialKeys.createCampaignDateKey,
        title: "التاريخ والوقت",
        description: "حدّد متى تبدأ المهمة ومتى تنتهي.",
        contentPosition: 0,
        stepIndex: 3,
        totalSteps: 5,
      ),
      TutorialService.createTarget(
        identify: "papers",
        keyTarget: AppTutorialKeys.createCampaignPapersKey,
        title: "إرفاق التصاريح",
        description: "ارفع أي أوراق تصاريح خاصة بالمهمة إن لزم الأمر.",
        contentPosition: 1,
        stepIndex: 4,
        totalSteps: 5,
      ),
      TutorialService.createTarget(
        identify: "volunteers",
        keyTarget: AppTutorialKeys.createCampaignVolunteersKey,
        title: "تعيين المتطوعين",
        description: "أخيراً.. اختر المتطوعين المناسبين لإنجاز هذه الحملة.",
        contentPosition: 0,
        stepIndex: 5,
        totalSteps: 5,
      ),
    ];
  }
}
