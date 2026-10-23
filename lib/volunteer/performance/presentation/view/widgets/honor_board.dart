import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/empty_state_text.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              AppIcons.trophy,
              size: AppSizes.iconL,
              color: ColorManager.starText,
            ),
            SizedBox(width: Space.s),
            Text('لوحة الشرف', style: AppText.title()),
          ],
        ),
        SizedBox(height: Space.vm),
        if (leaderboard.isEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorManager.surface,
              borderRadius: BorderRadius.circular(Radii.card),
            ),
            child: const AppEmptyState(
              title: 'لا يوجد ترتيب بعد',
              message: 'أكمل المهام لتجمع النقاط وتظهر هنا',
              icon: AppIcons.trophy,
              compact: true,
            ),
          )
        else
          for (var i = 0; i < leaderboard.length; i++)
            Padding(
              key: ValueKey(leaderboard[i].id),
              padding: EdgeInsets.only(bottom: Space.vs),
              child: LeaderRow(
                rank: i + 1,
                name: leaderboard[i].id == currentUserId
                    ? '${leaderboard[i].name} (أنا)'
                    : leaderboard[i].name,
                hours: leaderboard[i].totalHours,
                pts: leaderboard[i].pts,
                isMe: leaderboard[i].id == currentUserId,
              ),
            ),
      ],
    );
  }
}
