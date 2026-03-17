import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';
import 'leader_row.dart';

class HonorBoard extends StatelessWidget {
  const HonorBoard({
    super.key,
    required this.leaderboard,
    required this.currentUserId,
  });

  final List<LeaderboardEntryEntity> leaderboard;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final medals = ['🥇', '🥈', '🥉'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'لوحة الشرف  🏆',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.blueOne900,
                fontSize: FontSize.s16,
              ),
            ),
          ],
        ),
        SizedBox(height: AppHeight.s16),
        ...leaderboard.asMap().entries.map((entry) {
          final index = entry.key;
          final l = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: AppHeight.s10),
            child: LeaderRow(
              name: l.id == currentUserId ? '${l.name} (أنا)' : l.name,
              hours: l.totalHours,
              pts: l.pts,
              isMe: l.id == currentUserId,
              medal: index < 3 ? medals[index] : '${index + 1}',
            ),
          );
        }),
      ],
    );
  }
}
