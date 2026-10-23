import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

/// Gender picker styled by the app's input theme, so it matches the text
/// fields around it (fill, border, error text).
class GenderDropDown extends StatelessWidget {
  const GenderDropDown(this.gender, {super.key});
  final String? gender;

  static const _options = {'male': 'ذكر', 'female': 'أنثى'};

  @override
  Widget build(BuildContext context) {
    final itemStyle = getMediumStyle(
      fontSize: FontSize.s15,
      color: ColorManager.ink,
    );
    return DropdownButtonFormField<String>(
      initialValue: gender,
      isExpanded: true,
      validator: (value) => value == null ? 'اختر النوع' : null,
      onChanged: (value) {
        if (value != null) context.read<AuthCubit>().changeGender(value);
      },
      hint: Text(
        'اختر النوع',
        style: getRegularStyle(
          fontSize: FontSize.s14,
          color: ColorManager.inkFaint,
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: AppSizes.iconL,
        color: ColorManager.inkMuted,
      ),
      dropdownColor: ColorManager.surface,
      borderRadius: BorderRadius.circular(Radii.input),
      style: itemStyle,
      decoration: InputDecoration(
        prefixIcon: Icon(AppIcons.boy, size: AppSizes.iconM),
      ),
      items: [
        for (final e in _options.entries)
          DropdownMenuItem(
            value: e.key,
            child: Text(e.value, style: itemStyle),
          ),
      ],
    );
  }
}
