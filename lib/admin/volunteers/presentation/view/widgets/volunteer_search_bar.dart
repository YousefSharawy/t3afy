import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteers_cubit.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s16,
        vertical: AppHeight.s8,
      ),
      child: TextField(
        controller: _controller,
        textDirection: TextDirection.rtl,
        onChanged: (value) =>
            context.read<VolunteersCubit>().setSearchQuery(value),
        style: getMediumStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s13,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث باسم المتطوع أو المنطقة....',
          hintStyle: getMediumStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s13,
            color: Colors.white38,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
          filled: true,
          fillColor: const Color(0xFF0C203B),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppWidth.s16,
            vertical: AppHeight.s12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.s12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.s12),
            borderSide: const BorderSide(color: Color(0xFF1E3A5F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.s12),
            borderSide: const BorderSide(color: Color(0xFF00ABD2)),
          ),
        ),
      ),
    );
  }
}
