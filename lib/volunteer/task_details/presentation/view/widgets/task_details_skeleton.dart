import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/shimmers.dart';

/// First-load placeholder shaped like the header card, tabs and sections.
class TaskDetailsSkeleton extends StatelessWidget {
  const TaskDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: Space.gutter,
          vertical: Space.vs,
        ),
        children: [
          SkeletonBox(height: 168, radius: Radii.card),
          SizedBox(height: Space.vl),
          SkeletonBox(height: 44, radius: Radii.input),
          SizedBox(height: Space.vxl),
          SkeletonBox(height: 230, radius: Radii.card),
          SizedBox(height: Space.vl),
          SkeletonBox(height: 110, radius: Radii.card),
          SizedBox(height: Space.vl),
          SkeletonBox(height: 90, radius: Radii.card),
        ],
      ),
    );
  }
}
