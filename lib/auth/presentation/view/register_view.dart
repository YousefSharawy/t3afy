import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/auth/presentation/view/widgets/gender_drop_down.dart';
import 'package:t3afy/auth/presentation/view/widgets/role_switcher.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AuthCubit>();
      cubit.register(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text.trim(),
        role: cubit.isVolunteer ? 'user' : 'admin',
      );
    }
  }

  void _navigateByRole(String role) {
    switch (role) {
      case 'admin':
        context.go(Routes.adminHome);
        break;
      case 'user':
        context.go(Routes.volunteerHome);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (user) => _navigateByRole(user.role),
          error: (message) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message))),
        );
      },
      child: PrimaryScaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppWidth.s18,
              end: AppWidth.s18,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppHeight.s47),
                  Text(
                    "انشاء حساب جديد",
                    style: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.blueOne900,
                      fontSize: FontSize.s24,
                    ),
                  ),
                  SizedBox(height: AppHeight.s8),
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
                        color: ColorManager.blueOne700,
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
                  SizedBox(height: AppHeight.s16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "البريد الإلكتروني",
                      style: getSemiBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blueOne700,
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
                    validator: (value) => value?.isEmpty ?? true
                        ? 'ادخل البريد الإلكتروني'
                        : null,
                  ),
                  SizedBox(height: AppHeight.s8),
                  // Gender label
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "النوع",
                      style: getSemiBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blueOne700,
                        fontSize: FontSize.s18,
                      ),
                    ),
                  ),
                  SizedBox(height: AppHeight.s16),
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
                        color: ColorManager.blueOne700,
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
                  SizedBox(height: AppHeight.s29),
                  PrimaryElevatedButton(
                    width: AppWidth.s339,
                    height: AppHeight.s50,
                    title: 'إنشاء حساب',
                    onPress: _register,
                    textStyle: getBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s16,
                      color: ColorManager.white,
                    ),
                  ),
                  SizedBox(height: AppHeight.s10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " لديك حساب بالفعل؟",
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.blueOne800,
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
                            color: ColorManager.blueOne500,
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
      ),
    );
  }
}
