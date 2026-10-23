import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';

import 'check_in_card_shell.dart';

class CheckInLoadingCard extends StatelessWidget {
  const CheckInLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckInCardShell(
      icon: AppIcons.gps,
      tone: ColorManager.brand,
      title: 'جارٍ تحديد موقعك...',
      trailing: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: ColorManager.brand,
        ),
      ),
    );
  }
}

class CheckInPermissionDeniedCard extends StatelessWidget {
  const CheckInPermissionDeniedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckInCardShell(
      icon: AppIcons.location,
      tone: ColorManager.warning,
      title: 'إذن الموقع مطلوب',
      subtitle: 'يحتاج التطبيق إلى إذن الموقع لتسجيل حضورك تلقائياً',
      children: [
        SizedBox(height: Space.vm),
        PrimaryElevatedButton(
          title: 'فتح الإعدادات',
          icon: AppIcons.settings,
          onPress: () => Geolocator.openAppSettings(),
        ),
      ],
    );
  }
}

/// GPS failed, service disabled, or a check-in/out request failed.
class CheckInErrorCard extends StatelessWidget {
  const CheckInErrorCard({super.key, required this.state});
  final LocationError state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return CheckInCardShell(
      icon: AppIcons.offline,
      tone: ColorManager.error,
      title: 'تعذر تحديد الموقع',
      subtitle: state.message,
      children: [
        SizedBox(height: Space.vm),
        PrimaryElevatedButton(
          title: 'إعادة المحاولة',
          icon: AppIcons.refresh,
          onPress: () => cubit.retry(),
        ),
        SizedBox(height: Space.vxs),
        TextButton(
          onPressed: () => Geolocator.openAppSettings(),
          style: TextButton.styleFrom(
            foregroundColor: ColorManager.inkMuted,
            minimumSize: Size.fromHeight(AppSizes.touch),
          ),
          child: const Text('فتح الإعدادات'),
        ),
      ],
    );
  }
}
