import 'package:easy_localization/easy_localization.dart';
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
import 'package:t3afy/base/components.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/translation/locale_keys.g.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _navigateByRole(String role) {
    switch (role) {
      case 'admin':
        context.go(Routes.adminHome);
        break;
      case 'user':
        context.go(Routes.userHome);
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
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: AppWidth.s18,
              end: AppWidth.s18,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppHeight.s95),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      LocaleKeys.app_name.tr(),
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blue600,
                        fontSize: FontSize.s24,
                      ),
                    ),
                    SizedBox(width: AppWidth.s16),
                    Image.asset(
                      IconAssets.logo,
                      width: AppWidth.s67,
                      height: AppHeight.s47,
                    ),
                  ],
                ),
                SizedBox(height: AppHeight.s48),
                Text(
                  "مرحبًا بك",
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.blue900,
                    fontSize: FontSize.s18,
                  ),
                ),
                SizedBox(height: AppHeight.s32),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "البريد الالكترونى",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.blue700,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                PrimaryTextFF(
                  icon: IconAssets.email,
                  hint: "example@gmail.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'ادخل البريد الالكترونى' : null,
                ),
                SizedBox(height: AppHeight.s16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "كلمة المرور",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.blue700,
                      fontSize: FontSize.s18,
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                PrimaryTextFF(
                  prefixIcon: IconAssets.password,
                  isPassword: true,
                  hint: "*********",
                  controller: _passwordController,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'ادخل كلمة المرور' : null,
                ),
                SizedBox(height: AppHeight.s4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "نسيت كلمة المرور؟",
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.blue800,
                      fontSize: FontSize.s14,
                    ).copyWith(letterSpacing: -0.5.sp),
                  ),
                ),
                SizedBox(height: AppHeight.s31),
                PrimaryElevatedButton(
                  width: AppWidth.s339,
                  height: AppHeight.s50,
                  title: 'تسجيل الدخول',
                  onPress: _login,
                  textStyle: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s16,
                    color: ColorManager.white,
                  ),
                ),
                SizedBox(height: AppHeight.s32),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorManager.lightGray700,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppWidth.s4),
                      child: Text(
                        "المتابعة باستخدام",
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.lightGray700,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorManager.lightGray700,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppHeight.s32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      width: AppWidth.s34,
                      height: AppHeight.s34,
                      IconAssets.apple,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: AppWidth.s36,
                      ),
                      child: Image.asset(
                        width: AppWidth.s34,
                        height: AppHeight.s34,
                        IconAssets.google,
                      ),
                    ),
                    Image.asset(
                      width: AppWidth.s34,
                      height: AppHeight.s34,
                      IconAssets.facebook,
                    ),
                  ],
                ),
                SizedBox(height: AppHeight.s32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "  ليس لديك حساب ؟",
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blue800,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    SizedBox(width: AppWidth.s4),
                    GestureDetector(
                      onTap: () => context.go(Routes.register),
                      child: Text(
                        "انشاء حساب",
                        style: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.blue500,
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
