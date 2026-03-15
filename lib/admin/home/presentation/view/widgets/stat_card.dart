import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.trend,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s14,
        vertical: AppHeight.s14,
      ),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: ColorManager.blueOne700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.s10),
            ),
            child: Icon(icon, color: iconColor, size: 22.r),
          ),
          SizedBox(height: AppHeight.s10),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s22,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppHeight.s2),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstants.fontFamily,
              fontSize: FontSize.s12,
              color: ColorManager.blueTwo100,
            ),
          ),
          if (trend != null) ...[
            SizedBox(height: AppHeight.s4),
            Text(
              trend!,
              style: getRegularStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s10,
                color: const Color(0xFF00ABD2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
