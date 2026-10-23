import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/sheet_action_listener.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class UpgradeLevelSheet extends StatefulWidget {
  const UpgradeLevelSheet({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<UpgradeLevelSheet> createState() => _UpgradeLevelSheetState();
}

class _UpgradeLevelSheetState extends State<UpgradeLevelSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _levelCtrl;
  late final TextEditingController _titleCtrl;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _levelCtrl = TextEditingController(
      text: (widget.details.level + 1).toString(),
    );
    _titleCtrl = TextEditingController(text: widget.details.levelTitle);
  }

  @override
  void dispose() {
    _levelCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    context.read<VolunteerDetailsCubit>().upgradeLevel(
      level: int.parse(_levelCtrl.text.trim()),
      levelTitle: _titleCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetActionListener(
      onError: () => setState(() => _sending = false),
      child: VolunteerSheetFrame(
        title: 'ترقية المستوى',
        subtitle:
            'المستوى الحالي: ${widget.details.level} · ${widget.details.levelTitle}',
        icon: AppIcons.promotion,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryTextFF(
                label: 'المستوى الجديد',
                hint: 'رقم المستوى',
                controller: _levelCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null) return 'أدخل رقم المستوى';
                  if (n < 1) return 'المستوى يبدأ من 1';
                  return null;
                },
              ),
              SizedBox(height: Space.vm),
              PrimaryTextFF(
                label: 'لقب المستوى',
                hint: 'مثال: متطوع متقدم',
                controller: _titleCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'أدخل لقب المستوى'
                    : null,
              ),
              SizedBox(height: Space.vxl),
              PrimaryElevatedButton(
                title: 'حفظ المستوى',
                icon: AppIcons.promotion,
                isLoading: _sending,
                onPress: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
