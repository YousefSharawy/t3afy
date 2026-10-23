import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/profile/domain/entities/admin_profile_entity.dart';
import 'package:t3afy/admin/profile/presentation/cubit/admin_profile_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class AdminEditSheet extends StatefulWidget {
  const AdminEditSheet({super.key, required this.profile});

  final AdminProfileEntity profile;

  @override
  State<AdminEditSheet> createState() => _AdminEditSheetState();
}

class _AdminEditSheetState extends State<AdminEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _emailCtrl = TextEditingController(text: widget.profile.email);
    _phoneCtrl = TextEditingController(text: widget.profile.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    HapticFeedback.mediumImpact();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final phone = _phoneCtrl.text.trim();
    final error = await context.read<AdminProfileCubit>().updateProfile(
      userId: widget.profile.id,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: phone.isEmpty ? null : phone,
    );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
      Toast.success.show(context, title: 'تم حفظ التغييرات');
    } else {
      setState(() => _saving = false);
      Toast.error.show(context, title: error);
    }
  }

  static String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Space.gutter,
            Space.vl,
            Space.gutter,
            Space.vl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorManager.line,
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                  ),
                ),
                SizedBox(height: Space.vl),
                Text('تعديل الملف الشخصي', style: AppText.headline()),
                SizedBox(height: Space.vxl),
                PrimaryTextFF(
                  controller: _nameCtrl,
                  hint: 'الاسم',
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'اكتب الاسم'),
                ),
                SizedBox(height: Space.vm),
                PrimaryTextFF(
                  controller: _emailCtrl,
                  hint: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) => _required(v, 'اكتب البريد الإلكتروني'),
                ),
                SizedBox(height: Space.vm),
                PrimaryTextFF(
                  controller: _phoneCtrl,
                  hint: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: Space.vxl),
                PrimaryElevatedButton(
                  title: 'حفظ التغييرات',
                  onPress: _save,
                  isLoading: _saving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
