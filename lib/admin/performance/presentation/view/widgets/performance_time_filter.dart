import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class PerformanceTimeFilter extends StatefulWidget {
  const PerformanceTimeFilter({super.key});

  @override
  State<PerformanceTimeFilter> createState() => _PerformanceTimeFilterState();
}

class _PerformanceTimeFilterState extends State<PerformanceTimeFilter> {
  int _selected = 1; // شهور by default

  static const _labels = ['أسبوع', 'شهور', 'سنة'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: ColorManager.blueOne900,
        borderRadius: BorderRadius.circular(AppRadius.s12),
      ),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final selected = i == _selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: AppHeight.s8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF703DEB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: getBoldStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s12,
                    color: selected ? Colors.white : ColorManager.blueOne50,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
