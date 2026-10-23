import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/assign_existing_task_tab.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/assign_new_task_form.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/sheet_action_listener.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_segmented_tabs.dart';

/// Assign an existing upcoming task, or create a new one for this volunteer.
class AssignTaskSheet extends StatefulWidget {
  const AssignTaskSheet({super.key});

  @override
  State<AssignTaskSheet> createState() => _AssignTaskSheetState();
}

class _AssignTaskSheetState extends State<AssignTaskSheet> {
  int _tab = 0; // 0 = existing, 1 = new

  @override
  void initState() {
    super.initState();
    context.read<VolunteerDetailsCubit>().loadAvailableTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SheetActionListener(
      onError: () {},
      child: VolunteerSheetFrame(
        title: 'تعيين مهمة',
        icon: AppIcons.reports,
        height: 0.92.sh,
        scrollable: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSegmentedTabs(
              labels: const ['مهمة موجودة', 'مهمة جديدة'],
              selectedIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            SizedBox(height: Space.vl),
            Expanded(
              child: AnimatedSwitcher(
                duration: AppMotion.of(context),
                child: _tab == 0
                    ? const AssignExistingTaskTab(key: ValueKey(0))
                    : const AssignNewTaskForm(key: ValueKey(1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
