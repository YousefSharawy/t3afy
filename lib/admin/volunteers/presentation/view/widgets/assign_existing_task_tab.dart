import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
import 'package:t3afy/core/utils/date_ar.dart';

/// Upcoming / active tasks the volunteer isn't on yet. The last fetched list
/// stays visible while an assignment is in flight or after it fails.
class AssignExistingTaskTab extends StatefulWidget {
  const AssignExistingTaskTab({super.key});

  @override
  State<AssignExistingTaskTab> createState() => _AssignExistingTaskTabState();
}

class _AssignExistingTaskTabState extends State<AssignExistingTaskTab> {
  List<Map<String, dynamic>>? _tasks;

  @override
  void initState() {
    super.initState();
    final s = context.read<VolunteerDetailsCubit>().state;
    if (s is VolunteerDetailsAvailableTasks) _tasks = s.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VolunteerDetailsCubit, VolunteerDetailsState>(
      listenWhen: (_, s) => s is VolunteerDetailsAvailableTasks,
      listener: (_, s) =>
          setState(() => _tasks = (s as VolunteerDetailsAvailableTasks).tasks),
      builder: (context, state) {
        final tasks = _tasks;
        if (tasks == null) {
          if (state is VolunteerDetailsActionError) {
            return AppEmptyState(
              icon: AppIcons.offline,
              title: 'تعذّر تحميل المهام',
              actionLabel: 'إعادة المحاولة',
              onAction: () =>
                  context.read<VolunteerDetailsCubit>().loadAvailableTasks(),
              compact: true,
            );
          }
          return const SkeletonList(count: 3, padding: EdgeInsets.zero);
        }
        if (tasks.isEmpty) {
          return const AppEmptyState(
            icon: AppIcons.tasks,
            title: 'لا توجد مهام متاحة للتعيين',
            message: 'أنشئ مهمة جديدة من التبويب الآخر',
            compact: true,
          );
        }
        final busy = state is VolunteerDetailsActionLoading;
        return ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (_, _) => SizedBox(height: Space.vs),
          itemBuilder: (context, i) => _ExistingTaskItem(
            key: ValueKey(tasks[i]['id']),
            task: tasks[i],
            enabled: !busy,
          ),
        );
      },
    );
  }
}

class _ExistingTaskItem extends StatelessWidget {
  const _ExistingTaskItem({super.key, required this.task, required this.enabled});

  final Map<String, dynamic> task;
  final bool enabled;

  Future<void> _assign(BuildContext context, String title) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showConfirmDialog(
      context,
      title: 'تعيين المهمة',
      body: 'تعيين "$title" للمتطوع؟',
      confirmLabel: 'تعيين',
    );
    if (confirmed && context.mounted) {
      context.read<VolunteerDetailsCubit>().assignTask(
        taskId: task['id'] as String,
        adminId: LocalAppStorage.getUserId() ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = task['title'] as String? ?? '';
    final date = DateAr.tryParse(task['date']);
    final location = task['location_name'] as String? ?? '';
    final type = task['type'] as String? ?? '';

    return AppCard(
      onTap: enabled ? () => _assign(context, title) : null,
      semanticLabel: 'تعيين $title',
      padding: EdgeInsets.all(Space.m),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyStrong()),
                SizedBox(height: Space.vxs),
                Wrap(
                  spacing: Space.m,
                  runSpacing: Space.vxs,
                  children: [
                    if (date != null)
                      MetaItem(icon: AppIcons.calendar, text: DateAr.date(date)),
                    if (location.isNotEmpty)
                      MetaItem(icon: AppIcons.location, text: location),
                    if (type.isNotEmpty)
                      MetaItem(icon: AppIcons.camp, text: type),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: Space.s),
          Icon(
            AppIcons.add2,
            color: enabled ? ColorManager.brand : ColorManager.inkFaint,
            size: AppSizes.iconL,
          ),
        ],
      ),
    );
  }
}
