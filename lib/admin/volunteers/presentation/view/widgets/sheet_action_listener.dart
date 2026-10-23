import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/resources/extenstions.dart';

/// Closes an action sheet with a success toast, or calls [onError] so the
/// sheet can re-enable its button. The error toast itself comes from
/// VolunteerDetailsView (one place, no duplicates).
class SheetActionListener extends StatelessWidget {
  const SheetActionListener({
    super.key,
    required this.onError,
    required this.child,
  });

  final VoidCallback onError;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerDetailsCubit, VolunteerDetailsState>(
      listenWhen: (_, s) =>
          s is VolunteerDetailsActionSuccess || s is VolunteerDetailsActionError,
      listener: (context, state) {
        if (state is VolunteerDetailsActionSuccess) {
          Toast.success.show(context, title: state.message);
          Navigator.pop(context);
        } else {
          onError();
        }
      },
      child: child,
    );
  }
}
