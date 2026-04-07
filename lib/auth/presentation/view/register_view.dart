import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/auth/presentation/view/widgets/gender_drop_down.dart';
import 'package:t3afy/auth/presentation/view/widgets/role_switcher.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/primary_widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _idFile;
  bool _isPdf = false;
  bool _idError = false;
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.natural50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('اختر من المعرض'),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (picked != null) {
                  setState(() {
                    _idFile = File(picked.path);
                    _isPdf = false;
                    _idError = false;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('اختر ملف PDF'),
              onTap: () async {
                Navigator.pop(ctx);
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result != null && result.files.single.path != null) {
                  setState(() {
                    _idFile = File(result.files.single.path!);
                    _isPdf = true;
                    _idError = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeFile() {
    setState(() {
      _idFile = null;
      _isPdf = false;
    });
  }

  void _register() {
    if (_sending) return;
    HapticFeedback.mediumImpact();
    final cubit = context.read<AuthCubit>();
    final isVolunteer = cubit.isVolunteer;

    if (isVolunteer && _idFile == null) {
      setState(() => _idError = true);
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (isVolunteer && _idFile == null) return;
      setState(() => _sending = true);
      cubit.register(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text.trim(),
        role: isVolunteer ? 'user' : 'admin',
        idFile: _idFile,
      );
    }
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManager.natural50,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s20),
          ),
          title: Text(
            'تم إنشاء الحساب',
            style: getSemiBoldStyle(
              color: ColorManager.natural900,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'تم إنشاء حسابك بنجاح!\nحسابك قيد المراجعة من قبل الإدارة.\nسيتم إبلاغك عند الموافقة.',
            style: getRegularStyle(
              color: ColorManager.natural900.withValues(alpha: 0.7),
              fontSize: FontSize.s14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go(Routes.login);
              },
              child: Text(
                'العودة لتسجيل الدخول',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.primary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          registrationPending: () => _showPendingDialog(),
          error: (message) {
            setState(() => _sending = false);
            Toast.error.show(context, title: message);
          },
        );
      },
      child: PrimaryScaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: AppWidth.s18,
              end: AppWidth.s18,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppHeight.s47),
                Text(
                  "انشاء حساب جديد",
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.natural900,
                    fontSize: FontSize.s24,
                  ),
                ),
                SizedBox(height: AppHeight.s4),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) => current.maybeWhen(
                    orElse: () => false,
                    roleChanged: (_) => true,
                  ),
                  builder: (context, state) {
                    final isVolunteer = context.read<AuthCubit>().isVolunteer;
                    return RoleSwitcher(isVolunteer);
                  },
                ),
                SizedBox(height: AppHeight.s8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "الاسم كامل",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural900,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                PrimaryTextFF(
                  textAlign: TextAlign.right,
                  prefixIcon: IconAssets.person,
                  hint: "مثال.. يوسف احمد شعراوي",
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'ادخل الاسم' : null,
                ),
                SizedBox(height: AppHeight.s8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "البريد الإلكتروني",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural900,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                PrimaryTextFF(
                  icon: IconAssets.email,
                  hint: "name@gmail.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'ادخل البريد الإلكتروني' : null,
                ),
                SizedBox(height: AppHeight.s8),
                // Gender label
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "النوع",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural900,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) => current.maybeWhen(
                    orElse: () => false,
                    genderChanged: (_) => true,
                  ),
                  builder: (context, state) {
                    final gender = context.read<AuthCubit>().gender;
                    return GenderDropDown(gender);
                  },
                ),
                SizedBox(height: AppHeight.s8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "كلمة المرور",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural900,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                PrimaryTextFF(
                  icon: IconAssets.password,
                  isPassword: true,
                  hint: "***********",
                  controller: _passwordController,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'ادخل كلمة المرور' : null,
                ),
                SizedBox(height: AppHeight.s8),
                // Confirm Password label
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "تأكيد كلمة المرور",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.blueOne700,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                PrimaryTextFF(
                  icon: IconAssets.password,
                  isPassword: true,
                  hint: "***********",
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'ادخل تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppHeight.s16),
                // ── ID upload (volunteers only) ──
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (_, cur) => cur.maybeWhen(
                    orElse: () => false,
                    roleChanged: (_) => true,
                  ),
                  builder: (context, state) {
                    final isVolunteer = context.read<AuthCubit>().isVolunteer;
                    if (!isVolunteer) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'صورة الهوية',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.natural900,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        SizedBox(height: AppHeight.s8),
                        if (_idFile == null)
                          GestureDetector(
                            onTap: _pickFile,
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: Radius.circular(12.r),
                                color: _idError
                                    ? ColorManager.error
                                    : ColorManager.natural300,
                                strokeWidth: 1.5,
                                dashPattern: const [6, 4],
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  color: ColorManager.natural100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 32.r,
                                      color: ColorManager.natural500,
                                    ),
                                    SizedBox(height: AppHeight.s8),
                                    Text(
                                      'اضغط لرفع صورة الهوية',
                                      style: getSemiBoldStyle(
                                        fontFamily: FontConstants.fontFamily,
                                        color: ColorManager.natural700,
                                        fontSize: FontSize.s13,
                                      ),
                                    ),
                                    SizedBox(height: AppHeight.s4),
                                    Text(
                                      'JPG, PNG أو PDF — حد أقصى 5 ميجا',
                                      style: getRegularStyle(
                                        fontFamily: FontConstants.fontFamily,
                                        color: ColorManager.natural400,
                                        fontSize: FontSize.s12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: _isPdf
                                    ? Container(
                                        width: double.infinity,
                                        height: 120.h,
                                        color: ColorManager.natural100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf_outlined,
                                              size: 36.r,
                                              color: ColorManager.error,
                                            ),
                                            SizedBox(height: AppHeight.s8),
                                            Text(
                                              _idFile!.path.split('/').last,
                                              style: getRegularStyle(
                                                fontFamily:
                                                    FontConstants.fontFamily,
                                                color: ColorManager.natural700,
                                                fontSize: FontSize.s12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Image.file(
                                        _idFile!,
                                        width: double.infinity,
                                        height: 120.h,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              PositionedDirectional(
                                top: 8,
                                end: 8,
                                child: GestureDetector(
                                  onTap: _removeFile,
                                  child: Container(
                                    width: 24.r,
                                    height: 24.r,
                                    decoration: BoxDecoration(
                                      color: ColorManager.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: ColorManager.white,
                                      size: 14.r,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_idError)
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 4,
                              top: AppHeight.s4,
                            ),
                            child: Text(
                              'يجب رفع صورة الهوية',
                              style: getRegularStyle(
                                fontFamily: FontConstants.fontFamily,
                                color: ColorManager.error,
                                fontSize: FontSize.s12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                SizedBox(height: AppHeight.s24),
                PrimaryElevatedButton(
                  width: AppWidth.s339,
                  height: AppHeight.s46,
                  title: 'إنشاء حساب',
                  onPress: _sending ? () {} : _register,
                  isLoading: _sending,
                  textStyle: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s16,
                    color: ColorManager.white,
                  ),
                ),
                SizedBox(height: AppHeight.s24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " لديك حساب بالفعل؟",
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.natural700,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    SizedBox(width: AppWidth.s4),
                    GestureDetector(
                      onTap: () => context.go(Routes.login),
                      child: Text(
                        "تسجيل الدخول",
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.primary500,
                          fontSize: FontSize.s12,
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
    );
  }
}
