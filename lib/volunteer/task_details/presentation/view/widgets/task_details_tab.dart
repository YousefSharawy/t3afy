import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:t3afy/app/di.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import '../../../domain/entities/task_details_entity.dart';
import '../../../domain/entities/task_objective_entity.dart';
import 'submit_report_sheet.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/report_cubit.dart';

class TaskDetailsTab extends StatelessWidget {
  const TaskDetailsTab({super.key, required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasLocation) ...[
          _LocationSection(task: task),
          SizedBox(height: AppHeight.s12),
        ],
        if (task.description?.isNotEmpty == true) ...[
          _DescriptionSection(description: task.description!),
          SizedBox(height: AppHeight.s12),
        ],
        if (task.objectives.isNotEmpty) ...[
          _ObjectivesSection(objectives: task.objectives),
          SizedBox(height: AppHeight.s12),
        ],
        if (task.supervisorName != null) ...[
          _SupervisorSection(
            name: task.supervisorName!,
            phone: task.supervisorPhone,
          ),
          SizedBox(height: AppHeight.s12),
        ],
        if (task.notes?.isNotEmpty == true) ...[
          _NotesCard(notes: task.notes!),
          SizedBox(height: AppHeight.s12),
        ],
        _ReportButton(taskId: task.id, taskTitle: task.title),
        SizedBox(height: AppHeight.s24),
      ],
    );
  }

  bool get _hasLocation =>
      task.locationName != null ||
      (task.locationLat != null && task.locationLng != null);
}

// ─── Gradient card helper ──────────────────────────────────────────────────

class _GradientCard extends StatelessWidget {
  const _GradientCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s14,
            color: Colors.white,
          ),
        ),
        SizedBox(width: AppWidth.s8),
        Icon(icon, color: const Color(0xFF00ABD2), size: 20.r),
      ],
    );
  }
}

// ─── Location ─────────────────────────────────────────────────────────────

class _LocationSection extends StatelessWidget {
  const _LocationSection({required this.task});

  final TaskDetailsEntity task;

  @override
  Widget build(BuildContext context) {
    return _GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.location_on_rounded,
            title: 'الموقع',
          ),
          SizedBox(height: AppHeight.s10),
          if (task.locationName != null)
            Text(
              task.locationName!,
              textAlign: TextAlign.right,
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s13,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          if (task.locationAddress != null) ...[
            SizedBox(height: AppHeight.s4),
            Text(
              task.locationAddress!,
              textAlign: TextAlign.right,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
          SizedBox(height: AppHeight.s12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _MapButton(lat: task.locationLat, lng: task.locationLng),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.lat, required this.lng});

  final double? lat;
  final double? lng;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s12,
          vertical: AppHeight.s6,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF00ABD2).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.s8),
          border: Border.all(
            color: const Color(0xFF00ABD2).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'فتح في الخريطة',
              style: getMediumStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: const Color(0xFF00ABD2),
              ),
            ),
            SizedBox(width: AppWidth.s6),
            Icon(Icons.map_rounded, color: const Color(0xFF00ABD2), size: 16.r),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap() async {
    if (lat != null && lng != null) {
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─── Description ──────────────────────────────────────────────────────────

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return _GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.description_rounded,
            title: 'وصف المهمة',
          ),
          SizedBox(height: AppHeight.s10),
          Text(
            description,
            textAlign: TextAlign.right,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Objectives ───────────────────────────────────────────────────────────

class _ObjectivesSection extends StatelessWidget {
  const _ObjectivesSection({required this.objectives});

  final List<TaskObjectiveEntity> objectives;

  @override
  Widget build(BuildContext context) {
    return _GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _SectionHeader(
            icon: Icons.flag_rounded,
            title: 'الأهداف المطلوبة',
          ),
          SizedBox(height: AppHeight.s10),
          ...objectives.asMap().entries.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: AppHeight.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      e.value.title,
                      textAlign: TextAlign.right,
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  SizedBox(width: AppWidth.s10),
                  Container(
                    width: 26.sp,
                    height: 26.sp,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00ABD2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${e.key + 1}',
                      style: getBoldStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Supervisor ───────────────────────────────────────────────────────────

class _SupervisorSection extends StatelessWidget {
  const _SupervisorSection({required this.name, this.phone});

  final String name;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return _GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.person_rounded,
            title: 'المشرف المسؤول',
          ),
          SizedBox(height: AppHeight.s12),
          Row(
            children: [
                 Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00ABD2).withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24.r,
                ),
              ),
              SizedBox(width: AppWidth.s10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s14,
                      color: Colors.white,
                    ),
                  ),
                  if (phone != null) ...[
                    SizedBox(height: AppHeight.s2),
                    Text(
                      phone!,
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _launchSms(phone),
                    icon: Icon(
                      Icons.message_rounded,
                      color: const Color(0xFF00ABD2),
                      size: 22.r,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 36.r,
                      minHeight: 36.r,
                    ),
                  ),
                  SizedBox(width: AppWidth.s4),
                  IconButton(
                    onPressed: () => _launchPhone(phone),
                    icon: Icon(
                      Icons.phone_rounded,
                      color: const Color(0xFF00ABD2),
                      size: 22.r,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 36.r,
                      minHeight: 36.r,
                    ),
                  ),
                ],
              ),

           
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String? phone) async {
    if (phone != null) await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _launchSms(String? phone) async {
    if (phone != null) await launchUrl(Uri.parse('sms:$phone'));
  }
}

// ─── Notes (amber card) ───────────────────────────────────────────────────

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBBF24),
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'ملاحظات مهمة',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: const Color(0xFF0C203B),
                ),
              ),
              SizedBox(width: AppWidth.s6),
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFF0C203B),
                size: 20,
              ),
            ],
          ),
          SizedBox(height: AppHeight.s8),
          Text(
            notes,
            textAlign: TextAlign.right,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: const Color(0xFF0C203B),
            ),
          ),
        ],
      ),
    );
  }
}
// ─── Report button ────────────────────────────────────────────────────────
class _ReportButton extends StatelessWidget {
  const _ReportButton({required this.taskId, required this.taskTitle});

  final String taskId;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppHeight.s50,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => BlocProvider(
              create: (_) => getIt<ReportCubit>(),
              child: SubmitReportSheet(taskId: taskId, taskTitle: taskTitle),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00ABD2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s12),
          ),
          elevation: 0,
        ),
        child: Text(
          'رفع تقرير',
          style: getBoldStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
