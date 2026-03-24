import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class QualificationRow extends StatelessWidget {
  const QualificationRow({super.key, required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppHeight.s8),
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s12,
        vertical: AppHeight.s8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مجالات التطوع',
                  style: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s10,
                    color: ColorManager.natural700,
                  ),
                ),
                SizedBox(height: AppHeight.s8),
                values.isEmpty
                    ? Text(
                        '—',
                        style: getMediumStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s13,
                          color: ColorManager.natural900,
                        ),
                      )
                    : Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: values
                            .map(
                              (v) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppWidth.s10,
                                  vertical: AppHeight.s2,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.primary50,
                                  border: Border.all(
                                    width: 0.5.sp,
                                    color: ColorManager.primary500,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.s6),
                                ),
                                child: Text(
                                  v,
                                  style: getBoldStyle(
                                    fontFamily: FontConstants.fontFamily,
                                    fontSize: FontSize.s10,
                                    color: ColorManager.primary500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
