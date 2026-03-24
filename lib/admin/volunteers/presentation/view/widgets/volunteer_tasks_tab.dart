import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
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
    return Column(
      children: [
        Expanded(
          child: widget.details.tasks.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد مهام مسندة',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.details.tasks.length,
                  itemBuilder: (context, i) =>
                      VolunteerTaskCard(task: widget.details.tasks[i]),
                ),
        ),
      ],
    );
  }
}
