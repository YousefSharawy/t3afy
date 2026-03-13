import 'package:flutter/material.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ReportSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback? onPressed;
  final String label;

  const ReportSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onPressed,
    this.label = 'رفع التقرير',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppHeight.s50,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00ABD2),
          disabledBackgroundColor:
              const Color(0xFF00ABD2).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s12),
          ),
          elevation: 0,
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
