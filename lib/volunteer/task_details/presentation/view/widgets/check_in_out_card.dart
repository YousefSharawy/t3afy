import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/volunteer/task_details/presentation/cubit/location_cubit.dart';

import 'check_in/check_in_status_cards.dart';
import 'check_in/checked_in_card.dart';
import 'check_in/checked_out_card.dart';
import 'check_in/proximity_cards.dart';

/// Check-in / check-out card: one widget per [LocationState].
class CheckInOutCard extends StatefulWidget {
  const CheckInOutCard({super.key, required this.timeEnd, required this.date});

  final String timeEnd;
  final String date;

  @override
  State<CheckInOutCard> createState() => _CheckInOutCardState();
}

class _CheckInOutCardState extends State<CheckInOutCard> {
  // Set when the volunteer checks out on this screen, so the summary blooms
  // once instead of every time the screen opens.
  bool _celebrate = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (prev, curr) {
        if (curr is LocationCheckedOut && prev is! LocationCheckedOut) {
          _celebrate = prev is LocationCheckedIn;
        }
        return true;
      },
      builder: (context, state) {
        return AnimatedSize(
          duration: AppMotion.of(context),
          curve: AppMotion.enter,
          alignment: AlignmentDirectional.topCenter,
          child: switch (state) {
            LocationCheckedOut() => CheckedOutCard(
              state: state,
              celebrate: _celebrate,
            ),
            LocationCheckedIn() => CheckedInCard(
              state: state,
              timeEnd: widget.timeEnd,
              date: widget.date,
            ),
            LocationNearTask() => NearTaskCard(state: state),
            LocationFarFromTask() => FarFromTaskCard(state: state),
            LocationPermissionDenied() => const CheckInPermissionDeniedCard(),
            LocationError() => CheckInErrorCard(state: state),
            LocationLoading() => const CheckInLoadingCard(),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}
