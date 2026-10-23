import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t3afy/app/extenstions.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/auth/presentation/view/widgets/auth_field_label.dart';
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
      backgroundColor: ColorManager.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Space.vs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: ColorManager.brand,
                ),
                title: Text('اختر من المعرض', style: AppText.bodyStrong()),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (picked != null && mounted) {
                    setState(() {
                      _idFile = File(picked.path);
                      _isPdf = false;
                      _idError = false;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(AppIcons.pdf, color: ColorManager.brand),
                title: Text('اختر ملف PDF', style: AppText.bodyStrong()),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null &&
                      result.files.single.path != null &&
                      mounted) {
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
    FocusScope.of(context).unfocus();
    final cubit = context.read<AuthCubit>();
    final isVolunteer = cubit.isVolunteer;

    if (isVolunteer && _idFile == null) {
      setState(() => _idError = true);
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (isVolunteer && _idFile == null) return;
      setState(() => _sending = true);
      // Gender is validated but not sent: register() / the datasource have no
      // gender field yet.
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
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: ColorManager.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.card),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            Space.xl,
            Space.vxl,
            Space.xl,
            Space.vl,
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            Space.xl,
            0,
            Space.xl,
            Space.vxl,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.touch + Space.l,
                height: AppSizes.touch + Space.l,
                decoration: const BoxDecoration(
                  color: ColorManager.sproutSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.done2,
                  color: ColorManager.sproutText,
                  size: AppSizes.iconL + Space.xs,
                ),
              ),
              SizedBox(height: Space.vl),
              Text(
                'تم إنشاء الحساب',
                textAlign: TextAlign.center,
                style: AppText.headline(),
              ),
              SizedBox(height: Space.vs),
              Text(
                'حسابك الآن قيد المراجعة من الإدارة، وسنبلغك فور الموافقة عليه.',
                textAlign: TextAlign.center,
                style: AppText.body(color: ColorManager.inkMuted),
              ),
            ],
          ),
          actions: [
            PrimaryElevatedButton(
              width: double.infinity,
              title: 'العودة لتسجيل الدخول',
              onPress: () {
                Navigator.of(ctx).pop();
                context.go(Routes.login);
              },
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
        backgroundColor: ColorManager.canvas,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: Space.gutter),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Space.vxl),
                    Text(
                      'إنشاء حساب جديد',
                      textAlign: TextAlign.center,
                      style: getDisplayStyle(fontSize: FontSize.s24),
                    ),
                    SizedBox(height: Space.vs),
                    Text(
                      'اختر نوع الحساب ثم أكمل بياناتك',
                      textAlign: TextAlign.center,
                      style: AppText.body(color: ColorManager.inkMuted),
                    ),
                    SizedBox(height: Space.vxl),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (previous, current) => current.maybeWhen(
                        orElse: () => false,
                        roleChanged: (_) => true,
                      ),
                      builder: (context, state) =>
                          RoleSwitcher(context.read<AuthCubit>().isVolunteer),
                    ),
                    SizedBox(height: Space.vs),
                    const AuthFieldLabel('الاسم بالكامل'),
                    PrimaryTextFF(
                      iconData: AppIcons.person,
                      hint: 'مثال: يوسف أحمد شعراوي',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) =>
                          value?.trim().isEmpty ?? true ? 'أدخل الاسم' : null,
                    ),
                    const AuthFieldLabel('البريد الإلكتروني'),
                    PrimaryTextFF(
                      iconData: AppIcons.email,
                      hint: 'name@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'أدخل البريد الإلكتروني';
                        if (!v.isValidEmail()) {
                          return 'صيغة البريد الإلكتروني غير صحيحة';
                        }
                        return null;
                      },
                    ),
                    const AuthFieldLabel('النوع'),
                    GenderDropDown(context.read<AuthCubit>().gender),
                    const AuthFieldLabel('كلمة المرور'),
                    PrimaryTextFF(
                      iconData: AppIcons.password,
                      isPassword: true,
                      hint: '••••••••',
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'أدخل كلمة المرور' : null,
                    ),
                    const AuthFieldLabel('تأكيد كلمة المرور'),
                    PrimaryTextFF(
                      iconData: AppIcons.password,
                      isPassword: true,
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'أدخل تأكيد كلمة المرور';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمة المرور غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    // ── ID upload (volunteers only) ──
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (_, cur) => cur.maybeWhen(
                        orElse: () => false,
                        roleChanged: (_) => true,
                      ),
                      builder: (context, state) {
                        if (!context.read<AuthCubit>().isVolunteer) {
                          return const SizedBox.shrink();
                        }
                        return _buildIdUpload();
                      },
                    ),
                    SizedBox(height: Space.vxl),
                    PrimaryElevatedButton(
                      width: double.infinity,
                      title: 'إنشاء حساب',
                      onPress: _register,
                      isLoading: _sending,
                    ),
                    SizedBox(height: Space.vs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟',
                          style: getMediumStyle(
                            fontSize: FontSize.s13,
                            color: ColorManager.inkMuted,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(Routes.login),
                          style: TextButton.styleFrom(
                            minimumSize: Size(0, AppSizes.touch),
                            padding: EdgeInsets.symmetric(horizontal: Space.xs),
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: getBoldStyle(
                              fontSize: FontSize.s13,
                              color: ColorManager.brand,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Space.vl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdUpload() {
    final boxHeight = AppHeight.s120;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthFieldLabel('صورة الهوية'),
        if (_idFile == null)
          Semantics(
            button: true,
            label: 'رفع صورة الهوية',
            child: Material(
              color: _idError ? ColorManager.errorLight : ColorManager.brandSoft,
              borderRadius: BorderRadius.circular(Radii.input),
              child: InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(Radii.input),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(Radii.input),
                    color: _idError ? ColorManager.error : ColorManager.brand,
                    strokeWidth: 1.5,
                    dashPattern: const [6, 4],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: boxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          size: AppSizes.iconL + Space.s,
                          color: _idError
                              ? ColorManager.error
                              : ColorManager.brand,
                        ),
                        SizedBox(height: Space.vs),
                        Text(
                          'اضغط لرفع صورة الهوية',
                          style: getSemiBoldStyle(
                            fontSize: FontSize.s14,
                            color: ColorManager.ink,
                          ),
                        ),
                        SizedBox(height: Space.vxs),
                        Text(
                          'JPG أو PNG أو PDF — حد أقصى 5 ميجا',
                          style: AppText.caption(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.input),
                child: _isPdf
                    ? Container(
                        width: double.infinity,
                        height: boxHeight,
                        color: ColorManager.surfaceSunken,
                        padding: EdgeInsets.symmetric(horizontal: Space.l),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              AppIcons.pdf,
                              size: AppSizes.iconL + Space.s,
                              color: ColorManager.error,
                            ),
                            SizedBox(height: Space.vs),
                            Text(
                              _idFile!.path.split('/').last,
                              style: AppText.label(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    : Image.file(
                        _idFile!,
                        width: double.infinity,
                        height: boxHeight,
                        fit: BoxFit.cover,
                        cacheWidth:
                            (MediaQuery.sizeOf(context).width *
                                    MediaQuery.devicePixelRatioOf(context))
                                .round(),
                      ),
              ),
              PositionedDirectional(
                top: Space.xs,
                end: Space.xs,
                child: IconButton(
                  tooltip: 'إزالة الملف',
                  onPressed: _removeFile,
                  style: IconButton.styleFrom(
                    backgroundColor: ColorManager.surface,
                    foregroundColor: ColorManager.error,
                  ),
                  icon: Icon(AppIcons.x, size: AppSizes.iconM),
                ),
              ),
            ],
          ),
        if (_idError)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: Space.xs,
              top: Space.vxs,
            ),
            child: Text(
              'يجب رفع صورة الهوية',
              style: getRegularStyle(
                fontSize: FontSize.s12,
                color: ColorManager.error,
              ),
            ),
          ),
      ],
    );
  }
}
