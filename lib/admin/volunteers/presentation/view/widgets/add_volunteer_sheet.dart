import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
          loaded: (_, _, _) {
            if (_isSubmitting) {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.of(context).pop();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('تم إضافة المتطوع بنجاح'),
                  backgroundColor: ColorManager.success,
                ),
              );
            }
          },
          error: (message) {
            if (_isSubmitting) {
              setState(() => _isSubmitting = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: ColorManager.error,
                ),
              );
            }
          },
          orElse: () {},
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.blueOne900,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.s12),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 100,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: AppWidth.s40,
                        height: AppHeight.s3,
                        decoration: BoxDecoration(
                          color: ColorManager.blueOne100,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: AppHeight.s16),
                    Center(
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          Image.asset(IconAssets.add),
                          SizedBox(width: AppWidth.s4),
                          Text(
                            'إضافة متطوع جديد',
                            style: getBoldStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s14,
                              color: ColorManager.blueOne50,
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
                          color: ColorManager.blueOne100,
                        ),
                      ),
                    ),
                    SizedBox(height: AppHeight.s16),
                    _buildField(
                      label: 'الاسم الكامل',
                      controller: _nameController,
                      hint: 'مثال: ماريو عماد عزت',
                      icon: IconAssets.volHome,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'الاسم مطلوب'
                          : null,
                    ),
                    SizedBox(height: AppHeight.s8),
                    _buildField(
                      label: 'رقم الهاتف',
                      controller: _phoneController,
                      hint: 'مثال: 012-345-678',
                      icon: IconAssets.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: AppHeight.s8),
                    _buildField(
                      label: 'البريد الإلكتروني',
                      controller: _emailController,
                      hint: 'مثال: example@gmail.com',
                      icon: IconAssets.email2,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'البريد الإلكتروني مطلوب';
                        if (!v.contains('@')) return 'بريد إلكتروني غير صالح';
                        return null;
                      },
                    ),
                    SizedBox(height: AppHeight.s8),
                    _buildField(
                      label: 'المنطقة',
                      controller: _regionController,
                      hint: 'مثال: مدينة نصر',
                      icon: IconAssets.location,
                    ),
                    SizedBox(height: AppHeight.s8),
                    _buildField(
                      label: 'مجالات التطوع',
                      controller: _qualificationController,
                      hint: 'مثال: توعية, إعلام, دعم نفسي',
                      icon: IconAssets.target,
                    ),
                    SizedBox(height: AppHeight.s16),
                    Row(
                      children: [
                         Expanded(
                           child: TextButton(
                             onPressed: () => Navigator.of(context).pop(),
                             child: Text(
                               'إلغاء',
                               style: getBoldStyle(
                                 fontFamily: FontConstants.fontFamily,
                                 fontSize: FontSize.s16,
                                 color: ColorManager.white,
                               ),
                             ),
                           ),
                         ),
                           SizedBox(width: AppWidth.s8),
                        Expanded(
                          child: PrimaryElevatedButton(
                            height: AppHeight.s50,
                            title: 'إضافة متطوع',
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s14,
            color: ColorManager.blueOne100,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s14,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: ColorManager.blueOne100,
            ),
            prefixIcon: Image.asset(icon),
            filled: true,
            fillColor: ColorManager.blueOne800,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(
              12,
              14,
              12,
              14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E3A5F)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF00ABD2)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ColorManager.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ColorManager.error),
            ),
          ),
        ),
      ],
    );
  }
}
