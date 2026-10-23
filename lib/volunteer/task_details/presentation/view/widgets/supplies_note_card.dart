import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';

class SuppliesNoteCard extends StatelessWidget {
  const SuppliesNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: ColorManager.surfaceSunken,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(AppIcons.details, size: 20, color: ColorManager.inkFaint),
          SizedBox(width: Space.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ملاحظة المستلزمات', style: AppText.bodyStrong()),
                SizedBox(height: Space.vxs),
                Text(
                  'جميع المستلزمات ستكون جاهزة عند نقطة التجمع. يرجى التحقق من استلام الكميات المطلوبة قبل بدء المهمة.',
                  style: AppText.label(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
