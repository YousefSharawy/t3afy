import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
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

  void _submit() {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    context.read<VolunteersCubit>().addVolunteer(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      region: _regionController.text.trim().isEmpty
          ? null
          : _regionController.text.trim(),
      qualification: _qualificationController.text.trim().isEmpty
          ? null
          : _qualificationController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteersCubit, VolunteersState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (_, filter, searchQuery, pendingUsers, pendingLoading) {
            if (_isSubmitting) {
              Navigator.of(context).pop();
              Toast.success.show(context, title: 'تم إضافة المتطوع بنجاح');
            }
          },
          error: (message) {
            if (_isSubmitting) {
              setState(() => _isSubmitting = false);
              Toast.error.show(context, title: message);
            }
          },
          orElse: () {},
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.s12),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 100,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsetsDirectional.fromSTEB(18.sp, 18.sp, 18.sp, 26.sp),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: AppWidth.s39,
                        height: AppHeight.s3,
                        decoration: BoxDecoration(
                          color: ColorManager.natural400,
                          borderRadius: BorderRadius.circular(AppRadius.s49),
                        ),
                      ),
                    ),
                    SizedBox(height: AppHeight.s16),
                    Center(
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          Image.asset(IconAssets.add3),
                          SizedBox(width: AppWidth.s4),
                          Text(
                            'إضافة متطوع جديد',
                            style: getBoldStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s14,
                              color: ColorManager.natural700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppHeight.s4),
                    Center(
                      child: Text(
                        'البيانات الأساسية',
                        style: getRegularStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s10,
                          color: ColorManager.natural600,
                        ),
                      ),
                    ),
                    SizedBox(height: AppHeight.s16),
                    Text(
                      'الاسم الكامل',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: ColorManager.natural600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PrimaryTextFF(
                      textAlign: TextAlign.right,
                      hint: 'مثال: ماريو عماد عزت',
                      controller: _nameController,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الاسم مطلوب'
                          : null,
                    ),
                    SizedBox(height: AppHeight.s8),
                    Text(
                      'رقم الهاتف',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: ColorManager.natural600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PrimaryTextFF(
                      textAlign: TextAlign.right,
                      hint: 'مثال: 012-345-678',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppHeight.s8),
                    Text(
                      'البريد الإلكتروني',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: ColorManager.natural600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PrimaryTextFF(
                      textAlign: TextAlign.right,
                      hint: 'example@gmail.com:مثال',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'البريد الإلكتروني مطلوب';
                        }
                        if (!v.contains('@')) return 'بريد إلكتروني غير صالح';
                        return null;
                      },
                    ),
                    SizedBox(height: AppHeight.s8),
                    Text(
                      'المنطقة',
                      style: getBoldStyle(
                       fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: ColorManager.natural600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PrimaryTextFF(
                      textAlign: TextAlign.right,
                      hint: 'مثال: مدينة نصر',
                      controller: _regionController,
                    ),
                    SizedBox(height: AppHeight.s8),
                    Text(
                      'مجالات التطوع',
                      style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s14,
                        color: ColorManager.natural600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PrimaryTextFF(
                      textAlign: TextAlign.right,
                      hint: 'مثال: توعية, إعلام, دعم نفسي',
                      controller: _qualificationController,
                    ),
                    SizedBox(height: AppHeight.s16),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryElevatedButton(
                            backGroundColor: ColorManager.natural200,
                            title: 'إلغاء',
                            onPress: () => Navigator.of(context).pop(),
                            textStyle: getBoldStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s16,
                              color: ColorManager.natural600,
                            ),
                          ),
                        ),
                        SizedBox(width: AppWidth.s8),
                        Expanded(
                          child: PrimaryElevatedButton(
                            title: 'إضافة',
                            onPress: _submit,
                            isLoading: _isSubmitting,
                            textStyle: getBoldStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s16,
                              color: ColorManager.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
