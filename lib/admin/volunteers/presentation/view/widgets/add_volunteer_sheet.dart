import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class AddVolunteerSheet extends StatefulWidget {
  const AddVolunteerSheet({super.key});

  @override
  State<AddVolunteerSheet> createState() => _AddVolunteerSheetState();
}

class _AddVolunteerSheetState extends State<AddVolunteerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _regionController = TextEditingController();
  final _qualificationController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _regionController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  String? _orNull(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final error = await context.read<VolunteersCubit>().addVolunteer(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _orNull(_phoneController),
      region: _orNull(_regionController),
      qualification: _orNull(_qualificationController),
    );
    if (!mounted) return;
    if (error != null) {
      setState(() => _isSubmitting = false);
      Toast.error.show(context, title: error);
      return;
    }
    Toast.success.show(context, title: 'تمت إضافة المتطوع');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: Space.vm);
    return VolunteerSheetFrame(
      title: 'إضافة متطوع جديد',
      subtitle: 'البيانات الأساسية',
      icon: AppIcons.add3,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryTextFF(
              label: 'الاسم الكامل',
              hint: 'مثال: ماريو عماد عزت',
              controller: _nameController,
              iconData: AppIcons.person,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'الاسم مطلوب' : null,
            ),
            gap,
            PrimaryTextFF(
              label: 'رقم الهاتف (اختياري)',
              hint: '01xxxxxxxxx',
              controller: _phoneController,
              iconData: AppIcons.phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            gap,
            PrimaryTextFF(
              label: 'البريد الإلكتروني',
              hint: 'example@gmail.com',
              controller: _emailController,
              iconData: AppIcons.email2,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'البريد الإلكتروني مطلوب';
                }
                if (!v.contains('@')) return 'بريد إلكتروني غير صالح';
                return null;
              },
            ),
            gap,
            PrimaryTextFF(
              label: 'المنطقة (اختياري)',
              hint: 'مثال: مدينة نصر',
              controller: _regionController,
              iconData: AppIcons.location,
              textInputAction: TextInputAction.next,
            ),
            gap,
            PrimaryTextFF(
              label: 'مجالات التطوع (اختياري)',
              hint: 'مثال: توعية، إعلام، دعم نفسي',
              controller: _qualificationController,
              iconData: AppIcons.vol,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: Space.vxl),
            PrimaryElevatedButton(
              title: 'إضافة المتطوع',
              icon: AppIcons.add,
              isLoading: _isSubmitting,
              onPress: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
