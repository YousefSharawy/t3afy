import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

class ApproveButton extends StatelessWidget {
  const ApproveButton({super.key, required this.volunteerId});

  final String volunteerId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _confirmApprove(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppHeight.s8),
        padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s16,
          vertical: AppHeight.s14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorManager.successLight,
              Color(0xFF166534),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Row(
          children: [
            Container(
              width: AppWidth.s32,
              height: AppHeight.s32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.s8),
                color: const Color(0xFF22C55E).withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: ColorManager.successLight,
                size: 20.sp,
              ),
            ),
            SizedBox(width: AppWidth.s8),
            Text(
              'قبول المتطوع',
              style: getBoldStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: FontSize.s12,
                color: ColorManager.successLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmApprove(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManager.natural50,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.s20),
          ),
          title: Text(
            'قبول المتطوع',
            style: getSemiBoldStyle(
              color: ColorManager.natural900,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'هل أنت متأكد من قبول هذا المتطوع؟',
            style: getRegularStyle(
              color: ColorManager.natural900.withValues(alpha: 0.7),
              fontSize: FontSize.s14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'إلغاء',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.natural900.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary500,
                foregroundColor: ColorManager.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s30),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(ctx).pop();
                context.read<VolunteerDetailsCubit>().approveVolunteer(
                  volunteerId,
                );
              },
              child: Text(
                'قبول',
                style: getMediumStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: ColorManager.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
