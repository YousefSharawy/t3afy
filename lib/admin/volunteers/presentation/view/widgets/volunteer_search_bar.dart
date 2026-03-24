import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/base/widgets/app_form_field.dart';

class VolunteerSearchBar extends StatefulWidget {
  const VolunteerSearchBar({super.key});

  @override
  State<VolunteerSearchBar> createState() => _VolunteerSearchBarState();
}

class _VolunteerSearchBarState extends State<VolunteerSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      controller: _controller,
      hint: 'ابحث باسم المتطوع أو المنطقة....',
      prefixIcon: Image.asset(IconAssets.search),
      fillColor: ColorManager.natural100,
      borderColor: ColorManager.natural300,
      focusedBorderColor: ColorManager.natural300,
      textColor: ColorManager.natural400,
      hintColor: ColorManager.natural400,
      onChanged: (value) =>
          context.read<VolunteersCubit>().setSearchQuery(value),
    );
  }
}
