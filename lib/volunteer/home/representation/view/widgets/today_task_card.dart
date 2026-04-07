import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/campaigns/presentation/cubit/create_campaign_cubit.dart';
import 'package:t3afy/base/widgets/status_badge.dart';
import 'package:t3afy/volunteer/tasks/domain/entities/home_enities.dart';

class TodayTaskCard extends StatelessWidget {
  const TodayTaskCard({super.key, required this.task, this.onTap});

  final TaskEntity task;
  final VoidCallback? onTap;

  String get _effectiveStatus {
    final assignment = task.assignmentStatus;
    if (assignment == 'completed' || assignment == 'missed') return assignment;
    return task.status;
  }

  Color get _statusTextColor {
    switch (_effectiveStatus) {
      case 'ongoing':
      case 'active':
        return ColorManager.info;
      case 'upcoming':
        return ColorManager.warning;
      case 'completed':
      case 'done':
        return ColorManager.success;
      case 'missed':
        return ColorManager.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppWidth.s339,
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s8,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: BorderDirectional(
            start: BorderSide(color: _statusTextColor, width: AppWidth.s3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    task.title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      color: ColorManager.natural500,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  if (task.type.isNotEmpty) ...[
                    SizedBox(height: AppHeight.s2),
                    Row(
                      children: [
                        Icon(
                          taskTypeIcon(task.type),
                          size: 10,
                          color: ColorManager.natural400,
                        ),
                        SizedBox(width: AppWidth.s4),
                        Text(
                          task.type,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.natural400,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Row(
                    children: [
                      Image.asset(
                        IconAssets.hours,
                        width: AppWidth.s14,
                        height: AppHeight.s14,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Text(
                        '${task.timeStart} ص',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          color: ColorManager.natural300,
                          fontSize: FontSize.s10,
                        ),
                      ),
                      SizedBox(width: AppWidth.s4),
                      Image.asset(
                        IconAssets.location,
                        width: AppWidth.s14,
                        height: AppHeight.s14,
                      ),
                      SizedBox(width: AppWidth.s4),
                      Flexible(
                        child: Text(
                          task.locationName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.natural300,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Title
                ],
              ),
            ),
            Column(
              children: [
                StatusBadge(status: _effectiveStatus),
                Text(
                  '${task.points} +نقطة',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    color: ColorManager.warning,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
            //

            // ),
          ],
        ),
      ),
    );
  }
}
