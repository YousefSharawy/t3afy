import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/sheet_action_listener.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class EditVolunteerDataSheet extends StatefulWidget {
  const EditVolunteerDataSheet({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<EditVolunteerDataSheet> createState() => _EditVolunteerDataSheetState();
}

class _EditVolunteerDataSheetState extends State<EditVolunteerDataSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _regionCtrl;
  late final TextEditingController _qualCtrl;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    final d = widget.details;
    _nameCtrl = TextEditingController(text: d.name);
    _phoneCtrl = TextEditingController(text: d.phone ?? '');
    _emailCtrl = TextEditingController(text: d.email ?? '');
    _regionCtrl = TextEditingController(text: d.region ?? '');
    _qualCtrl = TextEditingController(text: d.qualification ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _regionCtrl.dispose();
    _qualCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final d = widget.details;
    final fields = <String, dynamic>{};
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final region = _regionCtrl.text.trim();
    final qual = _qualCtrl.text.trim();

    if (name != d.name) fields['name'] = name;
    if (phone != (d.phone ?? '')) fields['phone'] = phone;
    if (email != (d.email ?? '')) fields['email'] = email;
    if (region != (d.region ?? '')) fields['region'] = region;
    if (qual != (d.qualification ?? '')) fields['qualification'] = qual;

    if (fields.isEmpty) {
      Navigator.pop(context);
      return;
    }
    setState(() => _sending = true);
    context.read<VolunteerDetailsCubit>().editVolunteerData(fields);
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Space.vm);
    return SheetActionListener(
      onError: () => setState(() => _sending = false),
      child: VolunteerSheetFrame(
        title: 'تعديل البيانات',
        icon: AppIcons.edit,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryTextFF(
                label: 'الاسم',
                hint: 'الاسم الكامل',
                controller: _nameCtrl,
                iconData: AppIcons.person,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'الاسم مطلوب' : null,
              ),
              gap,
              PrimaryTextFF(
                label: 'رقم الهاتف',
                hint: '01xxxxxxxxx',
                controller: _phoneCtrl,
                iconData: AppIcons.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              gap,
              PrimaryTextFF(
                label: 'البريد الإلكتروني',
                hint: 'example@gmail.com',
                controller: _emailCtrl,
                iconData: AppIcons.email2,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isNotEmpty && !t.contains('@')) {
                    return 'بريد إلكتروني غير صالح';
                  }
                  return null;
                },
              ),
              gap,
              PrimaryTextFF(
                label: 'المنطقة',
                hint: 'مثال: مدينة نصر',
                controller: _regionCtrl,
                iconData: AppIcons.location,
                textInputAction: TextInputAction.next,
              ),
              gap,
              PrimaryTextFF(
                label: 'المؤهل',
                hint: 'مثال: بكالوريوس خدمة اجتماعية',
                controller: _qualCtrl,
                iconData: AppIcons.books,
              ),
              SizedBox(height: Space.vxl),
              PrimaryElevatedButton(
                title: 'حفظ التغييرات',
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
