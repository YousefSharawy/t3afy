import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/widgets/app_card.dart';

/// Volunteer areas (distinct task types the volunteer has worked on).
class QualificationRow extends StatelessWidget {
  const QualificationRow({super.key, required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مجالات التطوع', style: AppText.caption()),
          SizedBox(height: Space.vs),
          if (values.isEmpty)
            Text('—', style: AppText.bodyStrong())
          else
            Wrap(
              spacing: Space.s,
              runSpacing: Space.vs,
              children: [
                for (final v in values)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Space.m,
                      vertical: Space.vxs,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.brandSoft,
                      borderRadius: BorderRadius.circular(Radii.chip),
                    ),
                    child: Text(
                      v,
                      style: getSemiBoldStyle(
                        fontSize: FontSize.s12,
                        color: ColorManager.brandStrong,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
