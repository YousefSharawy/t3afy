import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

/// Primary action button. While [isLoading] the button keeps its size, shows
/// a spinner and ignores taps (no double submits).
class PrimaryElevatedButton extends StatelessWidget {
  const PrimaryElevatedButton({
    super.key,
    required this.title,
    this.height,
    this.width,
    required this.onPress,
    this.backGroundColor,
    this.titleWidget,
    this.isLoading = false,
    this.groub,
    this.value,
    this.icon,
    this.buttonRadius,
    this.textStyle,
    this.borderColor,
  });
  final String title;
  final double? height;
  final double? width;
  final VoidCallback onPress;
  final Color? backGroundColor;
  final Widget? titleWidget;
  final bool isLoading;
  final dynamic groub;
  final dynamic value;
  final IconData? icon;
  final Color? borderColor;

  final TextStyle? textStyle;
  final double? buttonRadius;

  @override
  Widget build(BuildContext context) {
    final iconData = icon;
    final bg = backGroundColor ?? ColorManager.brand;
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width ?? 1.sw,
        height: height ?? AppHeight.s48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            disabledBackgroundColor: bg.withValues(alpha: 0.7),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? ColorManager.transparent),
              borderRadius: BorderRadius.circular(buttonRadius ?? Radii.input),
            ),
            fixedSize: Size(width ?? 1.sw, height ?? AppHeight.s48),
          ),
          onPressed: isLoading
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onPress();
                },
          child: AnimatedSwitcher(
            duration: AppMotion.of(context, AppMotion.fast),
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    width: AppHeight.s22,
                    height: AppHeight.s22,
                    child: const CircularProgressIndicator(
                      color: ColorManager.white,
                      strokeWidth: 2.4,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : titleWidget ??
                      FittedBox(
                        key: const ValueKey('label'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (iconData != null) ...[
                              Icon(
                                iconData,
                                size: 18,
                                color: ColorManager.white,
                              ),
                              SizedBox(width: AppWidth.s8),
                            ],
                            Text(
                              title,
                              style:
                                  textStyle ??
                                  getSemiBoldStyle(
                                    fontSize: FontSize.s15,
                                    color: ColorManager.white,
                                  ),
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

class PrimaryTextFF extends StatefulWidget {
  const PrimaryTextFF({
    super.key,
    required this.hint,
    this.validator,
    this.label,
    this.maxLines = 1,
    this.controller,
    this.iconData,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.filledColor,
    this.textAlign,
    this.textInputAction,
    this.autofillHints,
  });
  final String hint;
  final String? label;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextEditingController? controller;

  final IconData? iconData;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Color? filledColor;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<PrimaryTextFF> createState() => _PrimaryTextFFState();
}

class _PrimaryTextFFState extends State<PrimaryTextFF> {
  late bool isObscure;
  @override
  void initState() {
    super.initState();
    isObscure = widget.isPassword;
  }

  bool get _isLtr {
    if (widget.isPassword) return true;
    final k = widget.keyboardType;
    return k == TextInputType.emailAddress ||
        k == TextInputType.phone ||
        k == TextInputType.number ||
        k == TextInputType.url ||
        k == TextInputType.visiblePassword;
  }

  @override
  Widget build(BuildContext context) {
    final lead =
        widget.iconData ?? (widget.isPassword ? AppIcons.password : null);
    return TextFormField(
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: 1,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      obscureText: isObscure,
      readOnly: widget.readOnly,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: widget.validator,
      textDirection: _isLtr ? TextDirection.ltr : null,
      textAlign: widget.textAlign ?? TextAlign.start,
      style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.ink),
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        fillColor: widget.filledColor,
        prefixIcon: lead == null ? null : Icon(lead, size: 20),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: isObscure ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                onPressed: () => setState(() => isObscure = !isObscure),
                icon: Icon(
                  isObscure ? AppIcons.visibilityoff : AppIcons.visibilityon,
                  size: 20,
                ),
              )
            : null,
      ),
    );
  }
}
