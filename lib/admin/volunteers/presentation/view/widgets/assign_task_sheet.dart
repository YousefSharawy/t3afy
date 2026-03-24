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
import 'package:t3afy/base/widgets/chip_badge.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
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
          height: 0.72.sh,
          padding: EdgeInsetsDirectional.fromSTEB(
            AppWidth.s20,
            AppHeight.s12,
            AppWidth.s20,
            AppHeight.s24,
          ),
          decoration: BoxDecoration(
            color: ColorManager.natural50,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.s20)),
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
          return const SizedBox(
            height: 120,
            child: LoadingIndicator(),
          );
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
                      [if (date.isNotEmpty) date, if (location.isNotEmpty) location]
                          .join(' · '),
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

class _NewTaskForm extends StatefulWidget {
  const _NewTaskForm({super.key});

  @override
  State<_NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<_NewTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = tomorrow;
    _dateCtrl.text = _fmtDate(tomorrow);
    _timeCtrl.text = '09:00';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
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

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeCtrl.text = _fmtTime(picked);
      });
    }
  }

  void _submit() {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final adminId = LocalAppStorage.getUserId() ?? '';
    final dateStr =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final timeStart = _fmtTime(_selectedTime);
    final endHour = (_selectedTime.hour + 1) % 24;
    final timeEnd =
        '${endHour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    context.read<VolunteerDetailsCubit>().assignCustomTask(
          adminId: adminId,
          title: _titleCtrl.text.trim(),
          type: 'مهمة فردية',
          locationName: _locationCtrl.text.trim(),
          date: dateStr,
          timeStart: timeStart,
          timeEnd: timeEnd,
          durationHours: 1.0,
          points: 10,
          notes:
              _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerDetailsCubit, VolunteerDetailsState>(
      listener: (context, state) {
        if (state is VolunteerDetailsActionError ||
            state is VolunteerDetailsActionSuccess) {
          if (mounted) setState(() => _submitting = false);
        }
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextFF(
                hint: 'عنوان المهمة',
                controller: _titleCtrl,
                textAlign: TextAlign.right,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              SizedBox(height: AppHeight.s12),
              PrimaryTextFF(
                hint: 'المكان',
                controller: _locationCtrl,
                textAlign: TextAlign.right,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              SizedBox(height: AppHeight.s12),
              PrimaryTextFF(
                hint: 'التاريخ',
                controller: _dateCtrl,
                readOnly: true,
                onTap: _pickDate,
                icon: IconAssets.calendar,
                textAlign: TextAlign.right,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              SizedBox(height: AppHeight.s12),
              PrimaryTextFF(
                hint: 'الوقت',
                controller: _timeCtrl,
                readOnly: true,
                onTap: _pickTime,
                icon: IconAssets.alarm,
                textAlign: TextAlign.right,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              SizedBox(height: AppHeight.s12),
              PrimaryTextFF(
                hint: 'ملاحظات (اختياري)',
                controller: _notesCtrl,
                maxLines: 2,
                textAlign: TextAlign.right,
              ),
              SizedBox(height: AppHeight.s24),
              PrimaryElevatedButton(
                title: _submitting ? '' : 'تعيين المهمة',
                titleWidget: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : null,
                onPress: _submitting ? () {} : _submit,
              ),
              SizedBox(height: AppHeight.s8),
            ],
          ),
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
