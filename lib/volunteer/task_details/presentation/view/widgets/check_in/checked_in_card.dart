import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';
import 'package:t3afy/base/widgets/confirm_dialog.dart';
import 'package:t3afy/base/widgets/star_bloom_progress.dart';
import 'package:t3afy/core/utils/date_ar.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';

import 'check_in_card_shell.dart';

/// Checked in — elapsed time, time left, and check-out once the task ends.
/// Only [_CheckInClock] ticks every second; the card itself rebuilds once,
/// when the deadline passes.
class CheckedInCard extends StatefulWidget {
  const CheckedInCard({
    super.key,
    required this.state,
    required this.timeEnd,
    required this.date,
  });

  final LocationCheckedIn state;
  final String timeEnd;
  final String date;

  @override
  State<CheckedInCard> createState() => _CheckedInCardState();
}

class _CheckedInCardState extends State<CheckedInCard> {
  late final DateTime _deadline = _buildDeadline();
  late bool _canCheckOut = !DateTime.now().isBefore(_deadline);
  bool _submitting = false;

  DateTime _buildDeadline() {
    try {
      final d = DateTime.parse(widget.date);
      final parts = widget.timeEnd.split(':');
      final endHour = int.tryParse(parts[0]) ?? 23;
      final endMin = int.tryParse(parts[1]) ?? 59;
      return DateTime(d.year, d.month, d.day, endHour, endMin);
    } catch (_) {
      return DateTime.now();
    }
  }

  Future<void> _checkOut(LocationCubit cubit) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showConfirmDialog(
      context,
      title: 'تسجيل الانصراف',
      body: 'هل تريد تسجيل انصرافك من المهمة؟',
      confirmLabel: 'تسجيل الانصراف',
    );
    if (!confirmed || !mounted) return;
    setState(() => _submitting = true);
    await cubit.checkOut();
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return CheckInCardShell(
      icon: AppIcons.checkIn,
      tone: ColorManager.sprout,
      title: 'تم تسجيل الحضور',
      subtitle:
          'وقت الحضور: ${DateAr.time(widget.state.checkedInAt.toLocal())}',
      children: [
        SizedBox(height: Space.vl),
        _CheckInClock(
          checkedInAt: widget.state.checkedInAt,
          deadline: _deadline,
          onDeadline: () {
            if (mounted && !_canCheckOut) setState(() => _canCheckOut = true);
          },
        ),
        SizedBox(height: Space.vl),
        if (_canCheckOut) ...[
          Text(
            'انتهت مدة المهمة، يمكنك تسجيل الانصراف الآن',
            textAlign: TextAlign.center,
            style: AppText.label(),
          ),
          SizedBox(height: Space.vm),
          PrimaryElevatedButton(
            title: 'تسجيل الانصراف',
            icon: AppIcons.checkOut,
            isLoading: _submitting,
            onPress: () => _checkOut(cubit),
          ),
        ] else
          Text(
            'سيتاح تسجيل الانصراف عند انتهاء وقت المهمة',
            textAlign: TextAlign.center,
            style: AppText.caption(),
          ),
      ],
    );
  }
}

class _CheckInClock extends StatefulWidget {
  const _CheckInClock({
    required this.checkedInAt,
    required this.deadline,
    required this.onDeadline,
  });

  final DateTime checkedInAt;
  final DateTime deadline;
  final VoidCallback onDeadline;

  @override
  State<_CheckInClock> createState() => _CheckInClockState();
}

class _CheckInClockState extends State<_CheckInClock> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
      if (!_now.isBefore(widget.deadline)) widget.onDeadline();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _hms(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _now.difference(widget.checkedInAt);
    final left = widget.deadline.difference(_now);
    final remaining = left.isNegative ? Duration.zero : left;
    final total = widget.deadline.difference(widget.checkedInAt);
    final ratio = total.inSeconds <= 0
        ? 1.0
        : (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);

    return Column(
      children: [
        Text('الوقت المنقضي', style: AppText.label()),
        SizedBox(height: Space.vxs),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            _hms(elapsed.isNegative ? Duration.zero : elapsed),
            style: getDisplayStyle(fontSize: 30, color: ColorManager.ink),
          ),
        ),
        SizedBox(height: Space.vm),
        StarBloomBar(value: ratio),
        SizedBox(height: Space.vs),
        Row(
          children: [
            Expanded(
              child: Text('متبقي على انتهاء المهمة', style: AppText.caption()),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                _hms(remaining),
                style: getNumericStyle(
                  fontSize: 13,
                  color: ColorManager.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
