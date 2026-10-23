import 'package:flutter/material.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/core/utils/date_ar.dart';

class VolunteerTaskCard extends StatelessWidget {
  const VolunteerTaskCard({super.key, required this.task});

  final VolunteerTaskAssignmentEntity task;

  IconData get _icon {
    if (task.title.contains('مستشفى') || task.title.contains('مستشفي')) {
      return AppIcons.hospital;
    }
    if (task.title.contains('توزيع')) return AppIcons.campaigns;
    return AppIcons.camp;
  }

  @override
  Widget build(BuildContext context) {
    final assigned = DateAr.tryParse(task.assignedAt);
    return AppCard(
      padding: EdgeInsets.all(Space.m),
      accent: StatusBadge.styleOf(task.status).accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBadge(icon: _icon),
              SizedBox(width: Space.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title.isNotEmpty ? task.title : 'مهمة',
                      style: AppText.bodyStrong(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (assigned != null)
                      Text(DateAr.date(assigned), style: AppText.caption()),
                  ],
                ),
              ),
              SizedBox(width: Space.s),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusBadge(status: task.status, compact: true),
                  if (task.isVerified) ...[
                    SizedBox(height: Space.vxs),
                    Text(
                      task.verifiedHours != null
                          ? '${task.verifiedHours!.toStringAsFixed(1)} س'
                          : 'محقق',
                      style: getNumericStyle(
                        fontSize: FontSize.s11,
                        color: ColorManager.sproutText,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (task.checkedInAt != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: Space.vs),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: ColorManager.line,
              ),
            ),
            _Attendance(task: task),
          ],
        ],
      ),
    );
  }
}

class _Attendance extends StatelessWidget {
  const _Attendance({required this.task});

  final VolunteerTaskAssignmentEntity task;

  @override
  Widget build(BuildContext context) {
    final checkedIn = DateAr.tryParse(task.checkedInAt);
    final checkedOut = DateAr.tryParse(task.checkedOutAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetaItem(
          icon: task.isVerified ? AppIcons.commit : AppIcons.warning,
          text: task.isVerified ? 'حضور مؤكد' : 'حضر، لم يتم التحقق بعد',
          color: task.isVerified
              ? ColorManager.sproutText
              : ColorManager.warning,
        ),
        SizedBox(height: Space.vxs),
        Wrap(
          spacing: Space.l,
          runSpacing: Space.vxs,
          children: [
            if (checkedIn != null)
              MetaItem(
                icon: AppIcons.checkIn,
                text: 'حضور: ${DateAr.time(checkedIn)}',
              ),
            if (checkedOut != null)
              MetaItem(
                icon: AppIcons.checkOut,
                text: 'انصراف: ${DateAr.time(checkedOut)}',
              ),
          ],
        ),
      ],
    );
  }
}
