import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/extenstions.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/routes.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/auth/presentation/view/widgets/auth_field_label.dart';
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
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _comingSoon() => Toast.info.show(context, title: 'قريباً');

  void _navigateByRole(String role) {
    switch (role) {
      case 'admin':
        context.go(Routes.adminHome);
        break;
      case 'volunteer':
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
          success: (user) {
            TextInput.finishAutofillContext();
            _navigateByRole(user.role);
          },
          error: (message) => Toast.error.show(context, title: message),
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
                  children: [
                    SizedBox(height: AppHeight.s48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.app_name.tr(),
                          style: getDisplayStyle(fontSize: FontSize.s24),
                        ),
                        SizedBox(width: Space.s),
                        Image.asset(
                          IconAssets.logo,
                          width: AppWidth.s67,
                          height: AppHeight.s47,
                        ),
                      ],
                    ),
                    SizedBox(height: Space.vs),
                    Text(
                      'سجّل دخولك لمتابعة رحلة التطوع',
                      textAlign: TextAlign.center,
                      style: AppText.body(color: ColorManager.inkMuted),
                    ),
                    SizedBox(height: AppHeight.s48),
                    const AuthFieldLabel(
                      'البريد الإلكتروني',
                      topGap: false,
                    ),
                    PrimaryTextFF(
                      iconData: AppIcons.email,
                      hint: 'example@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'أدخل البريد الإلكتروني';
                        if (!v.isValidEmail()) {
                          return 'صيغة البريد الإلكتروني غير صحيحة';
                        }
                        return null;
                      },
                    ),
                    const AuthFieldLabel('كلمة المرور'),
                    PrimaryTextFF(
                      iconData: AppIcons.password,
                      isPassword: true,
                      hint: '••••••••',
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'أدخل كلمة المرور' : null,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: _comingSoon,
                        style: TextButton.styleFrom(
                          minimumSize: Size(0, AppSizes.touch),
                          padding: EdgeInsets.symmetric(horizontal: Space.xs),
                        ),
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: getSemiBoldStyle(
                            fontSize: FontSize.s13,
                            color: ColorManager.brand,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Space.vl),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (prev, cur) => _isLoading(prev) != _isLoading(cur),
                      builder: (context, state) => PrimaryElevatedButton(
                        width: double.infinity,
                        title: 'تسجيل الدخول',
                        isLoading: _isLoading(state),
                        onPress: _login,
                      ),
                    ),
                    SizedBox(height: Space.vxxl),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: ColorManager.line)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Space.m),
                          child: Text(
                            'المتابعة باستخدام',
                            style: getMediumStyle(
                              fontSize: FontSize.s12,
                              color: ColorManager.inkMuted,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: ColorManager.line)),
                      ],
                    ),
                    SizedBox(height: Space.vxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          asset: IconAssets.apple,
                          label: 'Apple',
                          onTap: _comingSoon,
                        ),
                        SizedBox(width: Space.xl),
                        _SocialButton(
                          asset: IconAssets.google,
                          label: 'Google',
                          onTap: _comingSoon,
                        ),
                        SizedBox(width: Space.xl),
                        _SocialButton(
                          asset: IconAssets.facebook,
                          label: 'Facebook',
                          onTap: _comingSoon,
                        ),
                      ],
                    ),
                    SizedBox(height: Space.vxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: getMediumStyle(
                            fontSize: FontSize.s13,
                            color: ColorManager.inkMuted,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(Routes.register),
                          style: TextButton.styleFrom(
                            minimumSize: Size(0, AppSizes.touch),
                            padding: EdgeInsets.symmetric(horizontal: Space.xs),
                          ),
                          child: Text(
                            'إنشاء حساب',
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

  static bool _isLoading(AuthState s) =>
      s.maybeWhen(loading: () => true, orElse: () => false);
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.asset,
    required this.label,
    required this.onTap,
  });

  final String asset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: ColorManager.surface,
        shape: const CircleBorder(side: BorderSide(color: ColorManager.line)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: AppSizes.touch + Space.xs,
            child: Center(
              child: Image.asset(asset, width: 24, height: 24),
            ),
          ),
        ),
      ),
    );
  }
}
