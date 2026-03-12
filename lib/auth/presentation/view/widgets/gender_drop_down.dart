import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';

class GenderDropDown extends StatelessWidget {
  const GenderDropDown(this.gender, {super.key});
  final String? gender;
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) => gender == null ? 'اختر النوع' : null,
      builder: (FormFieldState<String> field) {
        return Column(
          children: [
            PopupMenuButton<String>(
              onSelected: (value) {
                context.read<AuthCubit>().changeGender(value);
                field.didChange(value);
              },
              offset: Offset(0.sp, 2.sp),
              position: PopupMenuPosition.under,
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              constraints: BoxConstraints(minWidth: AppWidth.s339),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'male',
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'ذكر',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blue600,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'female',
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'أنثى',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        color: ColorManager.blue600,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ),
              ],
              child: Container(
                constraints: BoxConstraints(minHeight: AppHeight.s54),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5.sp,
                    color: ColorManager.blue700,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Row(
                  children: [
                    SizedBox(width: AppWidth.s15),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.sp,
                      color: ColorManager.blue900,
                    ),
                    SizedBox(width: AppWidth.s12),
                    Text(
                      gender == 'male'
                          ? 'ذكر'
                          : gender == 'female'
                          ? 'أنثى'
                          : "ذكر",
                      style: TextStyle(
                        fontSize: FontSize.s14,
                        fontWeight: FontWeightManager.bold,
                        color: gender != null
                            ? ColorManager.blue600
                            : ColorManager.blue100,
                        fontFamily: FontConstants.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(
                  top: AppHeight.s8,
                  right: AppWidth.s12,
                ),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: FontSize.s12,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
