import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class EditVolunteerDataSheet extends StatefulWidget {
  const EditVolunteerDataSheet({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<EditVolunteerDataSheet> createState() => _EditVolunteerDataSheetState();
}

class _EditVolunteerDataSheetState extends State<EditVolunteerDataSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _regionCtrl;
  late final TextEditingController _qualCtrl;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.details.name);
    _phoneCtrl = TextEditingController(text: widget.details.phone ?? '');
    _emailCtrl = TextEditingController(text: widget.details.email ?? '');
    _regionCtrl = TextEditingController(text: widget.details.region ?? '');
    _qualCtrl = TextEditingController(text: widget.details.qualification ?? '');
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

  Future<void> _submit() async {
    HapticFeedback.mediumImpact();
    final fields = <String, dynamic>{};
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final region = _regionCtrl.text.trim();
    final qual = _qualCtrl.text.trim();

    if (name != widget.details.name) fields['name'] = name;
    if (phone != (widget.details.phone ?? '')) fields['phone'] = phone;
    if (email != (widget.details.email ?? '')) fields['email'] = email;
    if (region != (widget.details.region ?? '')) fields['region'] = region;
    if (qual != (widget.details.qualification ?? '')) {
      fields['qualification'] = qual;
    }

    if (fields.isEmpty) {
      Navigator.pop(context);
      return;
    }

    setState(() => _sending = true);
    context.read<VolunteerDetailsCubit>().editVolunteerData(fields);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerDetailsCubit, VolunteerDetailsState>(
      listener: (context, state) {
        if (state is VolunteerDetailsActionSuccess) {
          Navigator.pop(context);
          Toast.success.show(context, title: state.message);
        } else if (state is VolunteerDetailsActionError) {
          setState(() => _sending = false);
          Toast.error.show(context, title: state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsetsDirectional.all(AppSize.s20),
          decoration: BoxDecoration(
            color: ColorManager.natural50,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  'تعديل البيانات',
                  style: getSemiBoldStyle(
                    color: ColorManager.natural900,
                    fontSize: FontSize.s18,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'الاسم',
                  controller: _nameCtrl,
                ),
                SizedBox(height: AppHeight.s12),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'رقم الهاتف',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: AppHeight.s12),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'البريد الإلكتروني',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppHeight.s12),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'المنطقة',
                  controller: _regionCtrl,
                ),
                SizedBox(height: AppHeight.s12),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'المؤهل',
                  controller: _qualCtrl,
                ),
                SizedBox(height: AppHeight.s20),
                PrimaryElevatedButton(
                  title: _sending ? '' : 'حفظ التعديلات',
                  titleWidget: _sending
                      ? SizedBox(
                          width: AppWidth.s20,
                          height: AppHeight.s20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : null,
                  onPress: _sending ? () {} : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
