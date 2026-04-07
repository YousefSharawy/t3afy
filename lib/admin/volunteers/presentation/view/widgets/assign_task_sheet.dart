import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/app_form_field.dart';
import 'package:t3afy/base/widgets/chip_badge.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/admin/campaigns/presentation/view/widgets/dropdown_field.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/admin/campaigns/presentation/view/widgets/form_field_label.dart';
import 'package:t3afy/base/widgets/loading_indicator.dart';

class AssignTaskSheet extends StatefulWidget {
  const AssignTaskSheet({super.key});

  @override
  State<AssignTaskSheet> createState() => _AssignTaskSheetState();
}

class _AssignTaskSheetState extends State<AssignTaskSheet> {
  int _tab = 0; // 0 = existing, 1 = new

  @override
  void initState() {
    super.initState();
    // Kick off the available-tasks fetch for tab 0
    context.read<VolunteerDetailsCubit>().loadAvailableTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerDetailsCubit, VolunteerDetailsState>(
      listener: (context, state) {
        if (state is VolunteerDetailsActionSuccess) {
          Navigator.pop(context);
          Toast.success.show(context, title: state.message);
        } else if (state is VolunteerDetailsActionError) {
          Toast.error.show(context, title: state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 0.92.sh,
          padding: EdgeInsetsDirectional.fromSTEB(
            AppWidth.s20,
            AppHeight.s12,
            AppWidth.s20,
            AppHeight.s24,
          ),
          decoration: BoxDecoration(
            color: ColorManager.natural50,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.s20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: ColorManager.natural200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: AppHeight.s16),
              Text(
                'تعيين مهمة',
                style: getSemiBoldStyle(
                  color: ColorManager.natural900,
                  fontSize: FontSize.s18,
                  fontFamily: FontConstants.fontFamily,
                ),
              ),
              SizedBox(height: AppHeight.s12),
              // Tab selector
              Container(
                height: AppHeight.s40,
                decoration: BoxDecoration(
                  color: ColorManager.natural100,
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                ),
                child: Row(
                  children: [
                    _TabButton(
                      label: 'مهمة موجودة',
                      selected: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                    _TabButton(
                      label: 'مهمة جديدة',
                      selected: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppHeight.s16),
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _tab == 0
                      ? const _ExistingTaskTab(key: ValueKey(0))
                      : const _NewTaskForm(key: ValueKey(1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tab 1: pick existing task ────────────────────────────────────────────────

class _ExistingTaskTab extends StatelessWidget {
  const _ExistingTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolunteerDetailsCubit, VolunteerDetailsState>(
      builder: (context, state) {
        if (state is VolunteerDetailsActionLoading) {
          return const SizedBox(height: 120, child: LoadingIndicator());
        }
        if (state is VolunteerDetailsAvailableTasks) {
          if (state.tasks.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: EmptyStateText(message: 'لا توجد مهام متاحة للتعيين'),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: state.tasks.length,
            separatorBuilder: (_, _) => SizedBox(height: AppHeight.s8),
            itemBuilder: (context, i) {
              final task = state.tasks[i];
              return _ExistingTaskItem(task: task);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ExistingTaskItem extends StatelessWidget {
  const _ExistingTaskItem({required this.task});

  final Map<String, dynamic> task;

  @override
  Widget build(BuildContext context) {
    final title = task['title'] as String? ?? '';
    final date = (task['date'] as String? ?? '').split('T').first;
    final location = task['location_name'] as String? ?? '';
    final type = task['type'] as String? ?? '';

    return GestureDetector(
      onTap: () async {
        HapticFeedback.mediumImpact();
        final confirmed = await showConfirmDialog(
          context,
          title: 'تعيين المهمة',
          body: 'تعيين "$title" للمتطوع؟',
          confirmLabel: 'تعيين',
        );
        if (confirmed && context.mounted) {
          final adminId = LocalAppStorage.getUserId() ?? '';
          context.read<VolunteerDetailsCubit>().assignTask(
            taskId: task['id'] as String,
            adminId: adminId,
          );
        }
      },
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: AppWidth.s12,
          vertical: AppHeight.s12,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      color: ColorManager.natural900,
                      fontSize: FontSize.s13,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                  if (date.isNotEmpty || location.isNotEmpty) ...[
                    SizedBox(height: AppHeight.s4),
                    Text(
                      [
                        if (date.isNotEmpty) date,
                        if (location.isNotEmpty) location,
                      ].join(' · '),
                      style: getRegularStyle(
                        color: ColorManager.natural400,
                        fontSize: FontSize.s11,
                        fontFamily: FontConstants.fontFamily,
                      ),
                    ),
                  ],
                  if (type.isNotEmpty) ...[
                    SizedBox(height: AppHeight.s6),
                    ChipBadge(
                      type,
                      icon: IconAssets.camp,
                      color: ColorManager.primary500,
                      borderColor: ColorManager.primary500,
                      fillColor: ColorManager.primary50,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline_rounded,
              color: ColorManager.primary500,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 2: create new task ───────────────────────────────────────────────────

// campaignTypes is imported from create_campaign_cubit.dart

class _NewTaskForm extends StatefulWidget {
  const _NewTaskForm({super.key});

  @override
  State<_NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<_NewTaskForm> {
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
  DateTime? _selectedDate;
  TimeOfDay _timeStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _timeEnd = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = tomorrow;
    _dateCtrl.text = _fmtDate(tomorrow);
    _timeStartCtrl.text = '09:00';
    _timeEndCtrl.text = '10:00';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _locationCtrl.dispose();
    _locationAddressCtrl.dispose();
    _dateCtrl.dispose();
    _timeStartCtrl.dispose();
    _timeEndCtrl.dispose();
    _pointsCtrl.dispose();
    _supervisorNameCtrl.dispose();
    _supervisorPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = _fmtDate(picked);
      });
    }
  }

  Future<void> _pickTimeStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeStart,
    );
    if (picked != null) {
      setState(() {
        _timeStart = picked;
        _timeStartCtrl.text = _fmtTime(picked);
      });
    }
  }

  Future<void> _pickTimeEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeEnd,
    );
    if (picked != null) {
      setState(() {
        _timeEnd = picked;
        _timeEndCtrl.text = _fmtTime(picked);
      });
    }
  }

  void _submit(BuildContext context) {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;

    final adminId = LocalAppStorage.getUserId() ?? '';
    final dateStr =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    context.read<VolunteerDetailsCubit>().assignCustomTask(
      adminId: adminId,
      title: _titleCtrl.text.trim(),
      type: _selectedType,
      description: _descriptionCtrl.text.trim().isEmpty
          ? null
          : _descriptionCtrl.text.trim(),
      locationName: _locationCtrl.text.trim(),
      locationAddress: _locationAddressCtrl.text.trim().isEmpty
          ? null
          : _locationAddressCtrl.text.trim(),
      date: dateStr,
      timeStart: _fmtTime(_timeStart),
      timeEnd: _fmtTime(_timeEnd),
      durationHours: 0.0, // calculated in datasource from timeStart/timeEnd
      points: int.tryParse(_pointsCtrl.text.trim()) ?? 10,
      supervisorName: _supervisorNameCtrl.text.trim().isEmpty
          ? null
          : _supervisorNameCtrl.text.trim(),
      supervisorPhone: _supervisorPhoneCtrl.text.trim().isEmpty
          ? null
          : _supervisorPhoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const FormFieldLabel('عنوان المهمة'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _titleCtrl,
              hint: 'أدخل عنوان المهمة',
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            ),
            SizedBox(height: AppHeight.s12),

            // Type dropdown
            DropdownField(
              label: 'نوع المهمة',
              value: _selectedType,
              items: campaignTypes,
              onChanged: (v) =>
                  setState(() => _selectedType = v ?? _selectedType),
            ),
            SizedBox(height: AppHeight.s12),

            // Description
            const FormFieldLabel('وصف المهمة'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _descriptionCtrl,
              hint: 'اختياري',
              maxLines: 2,
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
            ),
            SizedBox(height: AppHeight.s12),

            // Location name
            const FormFieldLabel('اسم الموقع'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _locationCtrl,
              hint: 'اسم الموقع',
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            ),
            SizedBox(height: AppHeight.s12),

            // Location address
            const FormFieldLabel('العنوان التفصيلي'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _locationAddressCtrl,
              hint: 'اختياري',
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
            ),
            SizedBox(height: AppHeight.s12),

            // Date
            const FormFieldLabel('التاريخ'),
            SizedBox(height: AppHeight.s6),
            PrimaryTextFF(
              controller: _dateCtrl,
              hint: 'اختر التاريخ',
              readOnly: true,
              onTap: _pickDate,
              icon: IconAssets.calendar,
              textAlign: TextAlign.right,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
            ),
            SizedBox(height: AppHeight.s12),

            // Start / End time row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormFieldLabel('وقت البداية'),
                      SizedBox(height: AppHeight.s6),
                      PrimaryTextFF(
                        controller: _timeStartCtrl,
                        hint: '09:00',
                        readOnly: true,
                        onTap: _pickTimeStart,
                        icon: IconAssets.alarm,
                        textAlign: TextAlign.right,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppWidth.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FormFieldLabel('وقت النهاية'),
                      SizedBox(height: AppHeight.s6),
                      PrimaryTextFF(
                        controller: _timeEndCtrl,
                        hint: '10:00',
                        readOnly: true,
                        onTap: _pickTimeEnd,
                        icon: IconAssets.alarm,
                        textAlign: TextAlign.right,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppHeight.s12),

            // Points
            const FormFieldLabel('النقاط'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _pointsCtrl,
              hint: '10',
              keyboardType: TextInputType.number,
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
            ),
            SizedBox(height: AppHeight.s12),

            // Supervisor name
            const FormFieldLabel('اسم المشرف'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _supervisorNameCtrl,
              hint: 'اختياري',
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
            ),
            SizedBox(height: AppHeight.s12),

            // Supervisor phone
            const FormFieldLabel('هاتف المشرف'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _supervisorPhoneCtrl,
              hint: 'اختياري',
              keyboardType: TextInputType.phone,
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
            ),
            SizedBox(height: AppHeight.s12),

            // Notes
            const FormFieldLabel('ملاحظات'),
            SizedBox(height: AppHeight.s6),
            AppFormField(
              controller: _notesCtrl,
              hint: 'اختياري',
              maxLines: 2,
              fillColor: ColorManager.white,
              borderColor: ColorManager.natural200,
              focusedBorderColor: ColorManager.cyanPrimary,
              textColor: ColorManager.natural900,
              hintColor: ColorManager.natural400,
            ),
            SizedBox(height: AppHeight.s24),

            BlocBuilder<VolunteerDetailsCubit, VolunteerDetailsState>(
              buildWhen: (_, curr) =>
                  curr is VolunteerDetailsActionLoading ||
                  curr is VolunteerDetailsActionSuccess ||
                  curr is VolunteerDetailsActionError,
              builder: (context, state) {
                final isLoading = state is VolunteerDetailsActionLoading;
                return PrimaryElevatedButton(
                  title: isLoading ? '' : 'تعيين المهمة',
                  height: AppHeight.s52,
                  buttonRadius: AppRadius.s12,
                  isLoading: isLoading,
                  onPress: isLoading ? () {} : () => _submit(context),
                );
              },
            ),
            SizedBox(height: AppHeight.s8),
          ],
        ),
      ),
    );
  }
}

// ─── Shared tab button ────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: selected ? ColorManager.primary500 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.s24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: getSemiBoldStyle(
              color: selected ? ColorManager.white : ColorManager.natural400,
              fontSize: FontSize.s13,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
