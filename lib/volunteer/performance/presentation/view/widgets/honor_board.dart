import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/assets_manager.dart';
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
              'لوحة الشرف',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: ColorManager.natural900,
                fontSize: FontSize.s14,
              ),
            ),
            SizedBox(width: AppWidth.s6),
            Image.asset(
              IconAssets.trophy,
              width: AppWidth.s24,
              height: AppHeight.s24,
            ),
          ],
        ),
        SizedBox(height: AppHeight.s16),
        ...leaderboard.asMap().entries.map((entry) {
          final index = entry.key;
          final l = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: AppHeight.s8),
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
