import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/theme_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
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
    this.iconPath,
    this.buttonRadius,
    required this.textStyle,
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
  final String? iconPath;
  final Color? borderColor;

  final TextStyle textStyle;
  final double? buttonRadius;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(
          
          backgroundColor: backGroundColor ?? ColorManager.primary,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? ColorManager.trasnparent),
            borderRadius: BorderRadius.circular(buttonRadius ?? AppRadius.s20),
          ),
          fixedSize: Size(width ?? 1.sw, height ?? AppHeight.s48),
        ),
        onPressed: onPress,
        child:
            // isLoading
            //     ? LoadingAnimationWidget.staggeredDotsWave(
            //         color: ColorManager.white,
            //         size: AppWidth.s40,
            //       )
            //     :
            titleWidget ??
            FittedBox(
              child: Row(
                children: [
                  if (iconPath != null) ...[
                    Image.asset(
                      iconPath!,
                      width: AppWidth.s16,
                      height: AppHeight.s16,
                      color: ColorManager.white,
                    ),
                  ],
                  SizedBox(width: AppWidth.s8,),
                  Center(child: Text(title, style: textStyle)),
                ],
              ),
            ),
      ),
    );
  }
}

class PrimaryRadio extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged<dynamic> onChanged;

  const PrimaryRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(groupValue),
      borderRadius: BorderRadius.circular(AppRadius.s50),
      child: Container(
        alignment: Alignment.center,
        width: AppWidth.s30,
        height: AppWidth.s30,
        child: Container(
          width: AppWidth.s20,
          height: AppWidth.s20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: AppSize.s05, color: ColorManager.primary),
            color: isSelected ? ColorManager.primary : Colors.transparent,
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
    this.icon,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.filledColor,
  });
  final String hint;
  final String? label;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextEditingController? controller;
  final String? icon;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Color? filledColor;

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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      obscureText: isObscure,
      readOnly: widget.readOnly,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: AppHeight.s16),
        fillColor: widget.filledColor,
        constraints: BoxConstraints(minHeight: AppHeight.s56),
        labelText: widget.label ?? widget.hint,
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: FontSize.s14,
          fontWeight: FontWeightManager.regular,
          color: ColorManager.warmLightGray,
          fontFamily: FontConstants.almaraiFontFamily,
        ),
        focusedBorder: getOutlineInputBorder(
          color: widget.readOnly ? Colors.transparent : null,
          width: 0,
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: ColorManager.warmLightGray,
                  ),
                )
                : null,
        prefixIconConstraints: BoxConstraints(
          maxHeight: AppHeight.s14,
          minWidth: AppWidth.s16,
        ),
        prefixIcon:
            widget.icon != null
                ? Padding(
                  padding: EdgeInsets.only(
                    left: AppWidth.s12,
                    right: AppWidth.s20,
                  ),
                  child: PrimaryIcon(
                    icon: widget.icon!,
                    color: ColorManager.warmLightGray,
                  ),
                )
                : null,
      ),
    );
  }
}

class PrimaryCircularAvatar extends StatelessWidget {
  const PrimaryCircularAvatar({
    super.key,
    required this.size,
    this.child,
    this.image,
    this.color,
  });
  final double size;
  final Widget? child;
  final Color? color;
  final DecorationImage? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: image,
        color: color,
      ),
      child: child,
    );
  }
}

class PrimaryIcon extends StatelessWidget {
  const PrimaryIcon({super.key, required this.icon, this.color, this.size});
  final String icon;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,

      width: size ?? AppSize.s24,
      height: size ?? AppSize.s24,
      colorFilter:
          color != null
              ? ColorFilter.mode(color ?? ColorManager.primary, BlendMode.srcIn)
              : null,
    );
  }
}

// class BackBtn extends StatelessWidget {
//   const BackBtn({super.key, this.hasPopUp = false});
//   final bool hasPopUp;
//   @override
//   Widget build(BuildContext context) {
//     if (!hasRouteStack(context) && !hasPopUp) {
//       return SizedBox();
//     }
//     return Padding(
//       padding: EdgeInsets.all(AppSize.s6),
//       child: GestureDetector(
//         onTap: () => context.pop(),
//         child: Image.asset(IconAssets.arrowRight),
//       ),
//     );
//   }

  bool hasRouteStack(BuildContext context) {
    final router = GoRouter.of(context);
    final routeMatchList = router.routerDelegate.currentConfiguration.matches;

    // Debugging: Print the current route stack
    debugPrint('Route stack:');
    for (final route in routeMatchList) {
      debugPrint(route.matchedLocation);
    }

    // Return true if there's more than one route (meaning we can pop)
    return routeMatchList.length > 1;
  }
// }

class PrimaryIconBtn extends StatelessWidget {
  const PrimaryIconBtn({
    super.key,
    required this.icon,
    this.onPress,
    this.iconSize,
    this.iconColor,
    this.bgColor,
  });
  final String icon;
  final double? iconSize;
  final Color? iconColor;
  final Color? bgColor;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: AppSize.s50,
        width: AppWidth.s50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? ColorManager.lightGrey,
        ),
        alignment: Alignment.center,
        child: PrimaryIcon(
          icon: icon,
          size: iconSize ?? AppSize.s22,
          color: iconColor ?? ColorManager.primary,
        ),
      ),
    );
  }
}

class PrimaryOutlineButton extends StatelessWidget {
  const PrimaryOutlineButton({
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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backGroundColor ?? ColorManager.white,
          foregroundColor: ColorManager.primary,
          fixedSize: Size(width ?? 1.sw, height ?? AppHeight.s48),
        ),
        onPressed: onPress,
        child:
            // isLoading
            //     ? LoadingAnimationWidget.staggeredDotsWave(
            //         color: ColorManager.white,
            //         size: AppWidth.s40,
            //       )
            //     :
            titleWidget ?? Text(title),
      ),
    );
  }
}
