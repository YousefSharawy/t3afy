import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';

import 'check_in_card_shell.dart';

const _radius = 200.0;

/// Outside the 200 m ring — check-in shown but disabled.
class FarFromTaskCard extends StatelessWidget {
  const FarFromTaskCard({super.key, required this.state});
  final LocationFarFromTask state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return CheckInCardShell(
      icon: AppIcons.location,
      tone: ColorManager.inkFaint,
      title: 'أنت بعيد عن موقع المهمة',
      subtitle: 'المسافة: ${formatCheckInDistance(state.distance)}',
      children: [
        SizedBox(height: Space.vm),
        CheckInMiniMap(
          taskLat: cubit.taskLat,
          taskLng: cubit.taskLng,
          volunteerLat: state.currentLat,
          volunteerLng: state.currentLng,
          radiusMeters: _radius,
        ),
        SizedBox(height: Space.vm),
        Text(
          'اقترب إلى ٢٠٠ متر من الموقع لتسجيل حضورك',
          style: AppText.caption(),
        ),
        SizedBox(height: Space.vm),
        IgnorePointer(
          child: PrimaryElevatedButton(
            title: 'تسجيل الحضور',
            icon: AppIcons.checkIn,
            backGroundColor: ColorManager.natural300,
            onPress: () {},
          ),
        ),
      ],
    );
  }
}

/// Inside the ring — ready to check in.
class NearTaskCard extends StatefulWidget {
  const NearTaskCard({super.key, required this.state});
  final LocationNearTask state;

  @override
  State<NearTaskCard> createState() => _NearTaskCardState();
}

class _NearTaskCardState extends State<NearTaskCard> {
  bool _submitting = false;

  Future<void> _checkIn(LocationCubit cubit) async {
    HapticFeedback.mediumImpact();
    setState(() => _submitting = true);
    await cubit.checkIn();
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return CheckInCardShell(
      icon: AppIcons.location,
      tone: ColorManager.brand,
      title: 'أنت في موقع المهمة',
      subtitle: 'المسافة: ${formatCheckInDistance(widget.state.distance)}',
      children: [
        SizedBox(height: Space.vm),
        CheckInMiniMap(
          taskLat: cubit.taskLat,
          taskLng: cubit.taskLng,
          volunteerLat: widget.state.currentLat,
          volunteerLng: widget.state.currentLng,
          radiusMeters: _radius,
        ),
        SizedBox(height: Space.vm),
        PrimaryElevatedButton(
          title: 'تسجيل الحضور',
          icon: AppIcons.checkIn,
          isLoading: _submitting,
          onPress: () => _checkIn(cubit),
        ),
      ],
    );
  }
}
