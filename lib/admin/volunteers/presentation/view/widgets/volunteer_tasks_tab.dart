import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'volunteer_task_card.dart';

class VolunteerTasksTab extends StatefulWidget {
  const VolunteerTasksTab({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<VolunteerTasksTab> createState() => _VolunteerTasksTabState();
}

class _VolunteerTasksTabState extends State<VolunteerTasksTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tasks = widget.details.tasks;
    if (tasks.isEmpty) {
      return const AppEmptyState(
        icon: AppIcons.tasks,
        title: 'لا توجد مهام مسندة',
        message: 'عيّن مهمة من تبويب الإجراءات',
        compact: true,
      );
    }
    return ListView.separated(
      padding: EdgeInsets.only(
        top: Space.vs,
        bottom: Space.vxl + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => SizedBox(height: Space.vs),
      itemBuilder: (context, i) => VolunteerTaskCard(
        key: ValueKey('${tasks[i].id}-$i'),
        task: tasks[i],
      ),
    );
  }
}
