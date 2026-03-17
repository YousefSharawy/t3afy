import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import '../../../domain/entities/task_details_entity.dart';
import 'supplies_card.dart';
import 'supplies_note_card.dart';

class TaskSuppliesTab extends StatelessWidget {
  const TaskSuppliesTab({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SuppliesCard(supplies: task.supplies),
        SizedBox(height: AppHeight.s14),
        const SuppliesNoteCard(),
        SizedBox(height: AppHeight.s24),
      ],
    );
  }
}
