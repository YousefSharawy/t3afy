import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class EditRatingSheet extends StatefulWidget {
  const EditRatingSheet({super.key, required this.currentRating});

  final double currentRating;

  @override
  State<EditRatingSheet> createState() => _EditRatingSheetState();
}

class _EditRatingSheetState extends State<EditRatingSheet> {
  late int _selectedRating;
  final _commentCtrl = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.currentRating.round().clamp(1, 5);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    HapticFeedback.mediumImpact();
    setState(() => _sending = true);
    final adminId = LocalAppStorage.getUserId() ?? '';
    context.read<VolunteerDetailsCubit>().addRating(
      adminId: adminId,
      rating: _selectedRating,
      comment: _commentCtrl.text.trim().isEmpty
          ? null
          : _commentCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VolunteerDetailsCubit, VolunteerDetailsState>(
      listener: (context, state) {
        if (state is VolunteerDetailsActionSuccess) {
          Navigator.pop(context);
          Toast.success.show(context, title: state.message);
        } else if (state is VolunteerDetailsActionError) {
          setState(() => _sending = false);
          Toast.error.show(context, title: state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsetsDirectional.all(AppSize.s20),
          decoration: BoxDecoration(
            color: ColorManager.natural50,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: ColorManager.natural200,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                Text(
                  'تعديل التقييم',
                  style: getSemiBoldStyle(
                    color: ColorManager.natural900,
                    fontSize: FontSize.s18,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRating = starIndex),
                      child: Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 4.w,
                        ),
                        child: Icon(
                          starIndex <= _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: ColorManager.warning,
                          size: 36.sp,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: AppHeight.s16),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'تعليق (اختياري)',
                  controller: _commentCtrl,
                  maxLines: 3,
                ),
                SizedBox(height: AppHeight.s20),
                PrimaryElevatedButton(
                  title: _sending ? '' : 'حفظ التقييم',
                  titleWidget: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : null,
                  onPress: _sending ? () {} : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
