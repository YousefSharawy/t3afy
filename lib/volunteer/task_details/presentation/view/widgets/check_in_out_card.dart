import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';

class CheckInOutCard extends StatelessWidget {
  const CheckInOutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is LocationCheckedOut) {
          return _CheckedOutCard(state: state);
        }
        if (state is LocationCheckedIn) {
          return _CheckedInCard(state: state);
        }
        if (state is LocationNearTask) {
          return _NearTaskCard(state: state);
        }
        if (state is LocationFarFromTask) {
          return _FarFromTaskCard(state: state);
        }
        if (state is LocationPermissionDenied) {
          return _PermissionDeniedCard();
        }
        if (state is LocationLoading) {
          return _LoadingCard();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// State 1: Far from task
// ─────────────────────────────────────────────────────────────────
class _FarFromTaskCard extends StatelessWidget {
  const _FarFromTaskCard({required this.state});
  final LocationFarFromTask state;

  String _formatDistance(double metres) {
    if (metres >= 1000) {
      return '${(metres / 1000).toStringAsFixed(1)} كم';
    }
    return '${metres.round()} متر';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return _CardShell(
      borderColor: ColorManager.natural200,
      backgroundColor: ColorManager.natural100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniMap(
            taskLat: cubit.taskLat,
            taskLng: cubit.taskLng,
            volunteerLat: state.currentLat,
            volunteerLng: state.currentLng,
          ),
          SizedBox(height: AppHeight.s12),
          Row(
            children: [
              Icon(
                Icons.location_off_outlined,
                color: ColorManager.natural500,
                size: 20.r,
              ),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أنت بعيد عن موقع المهمة',
                      style: getMediumStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s13,
                        color: ColorManager.natural700,
                      ),
                    ),
                    Text(
                      'المسافة: ${_formatDistance(state.distance)}',
                      style: getRegularStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontSize: FontSize.s12,
                        color: ColorManager.natural500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s12),
          Text(
            'اقترب إلى ٢٠٠ متر من الموقع لتسجيل حضورك',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s11,
              color: ColorManager.natural400,
            ),
          ),
          SizedBox(height: AppHeight.s12),
          IgnorePointer(
            child: PrimaryElevatedButton(
              title: 'تسجيل الحضور',
              height: 50.h,
              backGroundColor: ColorManager.natural300,
              onPress: () {},
              textStyle: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s14,
                color: ColorManager.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// State 2: Near task — ready to check in
// ─────────────────────────────────────────────────────────────────
class _NearTaskCard extends StatefulWidget {
  const _NearTaskCard({required this.state});
  final LocationNearTask state;

  @override
  State<_NearTaskCard> createState() => _NearTaskCardState();
}

class _NearTaskCardState extends State<_NearTaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.05, end: 0.12).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return _CardShell(
      borderColor: ColorManager.primary500,
      backgroundColor: ColorManager.primary50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniMap(
            taskLat: cubit.taskLat,
            taskLng: cubit.taskLng,
            volunteerLat: widget.state.currentLat,
            volunteerLng: widget.state.currentLng,
          ),
          SizedBox(height: AppHeight.s12),
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) => Container(
              padding: EdgeInsetsDirectional.all(AppSize.s8),
              decoration: BoxDecoration(
                color: ColorManager.primary500.withValues(alpha: _pulse.value),
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: ColorManager.primary500,
                    size: 20.r,
                  ),
                  SizedBox(width: AppWidth.s8),
                  Text(
                    'أنت في موقع المهمة',
                    style: getMediumStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontSize.s13,
                      color: ColorManager.primary500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppHeight.s12),
          PrimaryElevatedButton(
            title: 'تسجيل الحضور 📍',
            height: 50.h,
            backGroundColor: ColorManager.primary500,
            onPress: () {
              HapticFeedback.mediumImpact();
              cubit.checkIn();
            },
            textStyle: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// State 3: Checked in — in progress
// ─────────────────────────────────────────────────────────────────
class _CheckedInCard extends StatefulWidget {
  const _CheckedInCard({required this.state});
  final LocationCheckedIn state;

  @override
  State<_CheckedInCard> createState() => _CheckedInCardState();
}

class _CheckedInCardState extends State<_CheckedInCard> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.state.checkedInAt);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(widget.state.checkedInAt);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatElapsed(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour;
    final m = local.minute.toString().padLeft(2, '0');
    final ampm = h >= 12 ? 'م' : 'ص';
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    return '$hour12:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return _CardShell(
      borderColor: ColorManager.success,
      backgroundColor: ColorManager.successLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GreenBadge(label: 'تم تسجيل الحضور ✓'),
              Text(
                'وقت الحضور: ${_formatTime(widget.state.checkedInAt)}',
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s11,
                  color: ColorManager.natural500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s12),
          Text(
            'الوقت المنقضي',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural500,
            ),
          ),
          SizedBox(height: AppHeight.s4),
          Text(
            _formatElapsed(_elapsed),
            style: getSemiBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s24,
              color: ColorManager.primary500,
            ),
          ),
          SizedBox(height: AppHeight.s16),
          PrimaryElevatedButton(
            title: 'تسجيل الانصراف 🏁',
            height: 50.h,
            backGroundColor: const Color(0xFFE05A3A),
            onPress: () async {
              HapticFeedback.mediumImpact();
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    backgroundColor: ColorManager.natural50,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s20),
                    ),
                    title: Text(
                      'تسجيل الانصراف',
                      style: getSemiBoldStyle(
                        color: ColorManager.natural900,
                        fontSize: FontSize.s18,
                      ),
                    ),
                    content: Text(
                      'هل تريد تسجيل انصرافك من المهمة؟',
                      style: getRegularStyle(
                        color: ColorManager.natural700,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                          'إلغاء',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s14,
                            color: ColorManager.natural500,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE05A3A),
                          foregroundColor: ColorManager.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.s30),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          'تسجيل الانصراف',
                          style: getMediumStyle(
                            fontFamily: FontConstants.fontFamily,
                            fontSize: FontSize.s14,
                            color: ColorManager.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              if (confirmed == true && context.mounted) {
                cubit.checkOut();
              }
            },
            textStyle: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s14,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// State 4: Checked out — completed
// ─────────────────────────────────────────────────────────────────
class _CheckedOutCard extends StatelessWidget {
  const _CheckedOutCard({required this.state});
  final LocationCheckedOut state;

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final h = local.hour;
    final m = local.minute.toString().padLeft(2, '0');
    final ampm = h >= 12 ? 'م' : 'ص';
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    return '$hour12:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      borderColor: ColorManager.natural200,
      backgroundColor: ColorManager.natural100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GreenBadge(label: 'تم تسجيل الحضور والانصراف ✓'),
              _VerifiedBadge(),
            ],
          ),
          SizedBox(height: AppHeight.s12),
          _SummaryRow(
              label: 'وقت الحضور',
              value: _formatTime(state.checkedInAt)),
          _SummaryRow(
              label: 'وقت الانصراف',
              value: _formatTime(state.checkedOutAt)),
          _SummaryRow(
            label: 'المدة الفعلية',
            value: '${state.verifiedHours} ساعة',
            bold: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Permission denied
// ─────────────────────────────────────────────────────────────────
class _PermissionDeniedCard extends StatelessWidget {
  const _PermissionDeniedCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      borderColor: ColorManager.warning,
      backgroundColor: ColorManager.warningLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_off_outlined,
                  color: ColorManager.warning, size: 20.r),
              SizedBox(width: AppWidth.s8),
              Expanded(
                child: Text(
                  'يحتاج التطبيق إلى إذن الموقع لتسجيل حضورك تلقائياً',
                  style: getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.warning,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.s12),
          PrimaryElevatedButton(
            title: 'فتح الإعدادات',
            height: 44.h,
            backGroundColor: ColorManager.warning,
            onPress: () => Geolocator.openAppSettings(),
            textStyle: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s13,
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      borderColor: ColorManager.natural200,
      backgroundColor: ColorManager.natural100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18.r,
            height: 18.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.primary500,
            ),
          ),
          SizedBox(width: AppWidth.s8),
          Text(
            'جارٍ تحديد موقعك...',
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────────────
class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.child,
    required this.borderColor,
    required this.backgroundColor,
  });

  final Widget child;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(AppSize.s16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: child,
    );
  }
}

class _MiniMap extends StatelessWidget {
  const _MiniMap({
    required this.taskLat,
    required this.taskLng,
    required this.volunteerLat,
    required this.volunteerLng,
  });

  final double taskLat;
  final double taskLng;
  final double volunteerLat;
  final double volunteerLng;

  @override
  Widget build(BuildContext context) {
    final centerLat = (taskLat + volunteerLat) / 2;
    final centerLng = (taskLng + volunteerLng) / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 120.h,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(centerLat, centerLng),
            initialZoom: 14,
            interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.none),
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.t3afy.app',
            ),
            // 200m radius circle
            CircleLayer(
              circles: [
                CircleMarker(
                  point: LatLng(taskLat, taskLng),
                  radius: 200,
                  useRadiusInMeter: true,
                  color: ColorManager.primary500.withValues(alpha: 0.08),
                  borderColor: ColorManager.primary500.withValues(alpha: 0.4),
                  borderStrokeWidth: 1.5,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                // Task pin
                Marker(
                  point: LatLng(taskLat, taskLng),
                  width: 30.r,
                  height: 30.r,
                  child: Icon(
                    Icons.location_pin,
                    color: ColorManager.primary500,
                    size: 30.r,
                  ),
                ),
                // Volunteer dot
                Marker(
                  point: LatLng(volunteerLat, volunteerLng),
                  width: 14.r,
                  height: 14.r,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      color: ColorManager.info,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: ColorManager.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GreenBadge extends StatelessWidget {
  const _GreenBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s8,
        vertical: AppHeight.s4,
      ),
      decoration: BoxDecoration(
        color: ColorManager.successLight,
        borderRadius: BorderRadius.circular(AppRadius.s6),
        border: Border.all(color: ColorManager.success, width: 0.5),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: FontSize.s10,
          color: ColorManager.success,
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified_outlined,
            color: ColorManager.success, size: 14.r),
        SizedBox(width: AppWidth.s4),
        Text(
          'تم التحقق',
          style: getRegularStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontSize.s10,
            color: ColorManager.success,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(
      {required this.label, required this.value, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.s6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.natural500,
            ),
          ),
          Text(
            value,
            style: bold
                ? getSemiBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s13,
                    color: ColorManager.primary500,
                  )
                : getMediumStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: ColorManager.natural700,
                  ),
          ),
        ],
      ),
    );
  }
}
