import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/auth/presentation/cubit/auth_cubit.dart';
import 'package:t3afy/base/widgets/app_segmented_tabs.dart';

/// Account type picker on the register screen (admin / volunteer).
class RoleSwitcher extends StatelessWidget {
  const RoleSwitcher(this.isVolunteer, {super.key});
  final bool isVolunteer;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedTabs(
      labels: const ['مشرف', 'متطوع'],
      selectedIndex: isVolunteer ? 1 : 0,
      onChanged: (i) => context.read<AuthCubit>().toggleRole(i == 1),
    );
  }
}
