import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

/// Search field. Typing is debounced (250 ms) so the list re-filters once per
/// pause instead of on every keystroke.
class VolunteerSearchBar extends StatefulWidget {
  const VolunteerSearchBar({super.key});

  @override
  State<VolunteerSearchBar> createState() => _VolunteerSearchBarState();
}

class _VolunteerSearchBarState extends State<VolunteerSearchBar> {
  static const _debounce = Duration(milliseconds: 250);

  final _controller = TextEditingController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {}); // toggles the clear button
    _timer?.cancel();
    _timer = Timer(_debounce, () {
      if (mounted) context.read<VolunteersCubit>().setSearchQuery(value.trim());
    });
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    setState(() {});
    context.read<VolunteersCubit>().setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      style: getMediumStyle(fontSize: FontSize.s15, color: ColorManager.ink),
      decoration: InputDecoration(
        hintText: 'ابحث باسم المتطوع أو المنطقة',
        fillColor: ColorManager.surface,
        prefixIcon: Icon(AppIcons.search, size: AppSizes.iconM),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'مسح البحث',
                onPressed: _clear,
                icon: Icon(AppIcons.x, size: AppSizes.iconM),
              ),
      ),
    );
  }
}
