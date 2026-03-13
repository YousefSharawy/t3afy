import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/volunteer/performance/domain/entities/performance_entities.dart';

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
        // Title
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
        // Rows
        ...leaderboard.asMap().entries.map((entry) {
          final index = entry.key;
          final l = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: AppHeight.s10),
            child: _LeaderRow(
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

class _LeaderRow extends StatelessWidget {
  const _LeaderRow({
    required this.name,
    required this.hours,
    required this.pts,
    required this.isMe,
    required this.medal,
  });

  final String name;
  final int hours;
  final int pts;
  final bool isMe;
  final String medal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppHeight.s12,
        horizontal: AppWidth.s16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0C203B), Color(0xFF143764)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: isMe
            ? Border.all(color: ColorManager.blueThree500, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          // Points
          Text(medal, style: TextStyle(fontSize: 24.sp)),
          SizedBox(width: AppWidth.s8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.white,
                  fontSize: FontSize.s14,
                ),
              ),
              Text(
                '$hours ساعة',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  color: ColorManager.blueTwo100,
                  fontSize: FontSize.s11,
                ),
              ),
            ],
          ),

          const Spacer(),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppWidth.s12,
              vertical: AppHeight.s4,
            ),
            decoration: BoxDecoration(
              color: ColorManager.blueThree500.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            child: Text(
              'pts $pts',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                color: Color(0xffFFCD0F),
                fontSize: FontSize.s12,
              ),
            ),
          ),

          // Medal
        ],
      ),
    );
  }
}
//  ColorManager.blueThree300,