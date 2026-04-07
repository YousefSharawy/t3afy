import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.volunteerId});

  final String volunteerId;

  @override
  Widget build(BuildContext context) {
    return PrimaryElevatedButton(
      title: 'حذف المتطوع',
      onPress: () {
        HapticFeedback.mediumImpact();
        _confirmDelete(context);
      },
      backGroundColor: ColorManager.errorLight,
      textStyle: getBoldStyle(
        fontFamily: FontConstants.fontFamily,
        fontSize: FontSize.s16,
        color: ColorManager.error,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
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
            'حذف المتطوع',
            style: getSemiBoldStyle(
              color: ColorManager.natural900,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف هذا المتطوع؟ لا يمكن التراجع عن هذا الإجراء.',
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
                backgroundColor: ColorManager.error,
                foregroundColor: ColorManager.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s30),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(ctx).pop();
                context.read<VolunteerDetailsCubit>().deleteVolunteer(
                  volunteerId,
                );
              },
              child: Text(
                'حذف',
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
