import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/sheet_action_listener.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';
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

  void _submit() {
    setState(() => _sending = true);
    final comment = _commentCtrl.text.trim();
    context.read<VolunteerDetailsCubit>().addRating(
      adminId: LocalAppStorage.getUserId() ?? '',
      rating: _selectedRating,
      comment: comment.isEmpty ? null : comment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetActionListener(
      onError: () => setState(() => _sending = false),
      child: VolunteerSheetFrame(
        title: 'تعديل التقييم',
        icon: AppIcons.star,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final star = index + 1;
                final on = star <= _selectedRating;
                return IconButton(
                  tooltip: '$star من 5',
                  iconSize: AppSizes.iconL * 1.5,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedRating = star);
                  },
                  icon: Icon(
                    on ? AppIcons.star : AppIcons.unstar,
                    color: on ? ColorManager.star : ColorManager.inkFaint,
                  ),
                );
              }),
            ),
            SizedBox(height: Space.vl),
            PrimaryTextFF(
              label: 'تعليق (اختياري)',
              hint: 'ملاحظة عن أداء المتطوع',
              controller: _commentCtrl,
              maxLines: 3,
            ),
            SizedBox(height: Space.vxl),
            PrimaryElevatedButton(
              title: 'حفظ التقييم',
              isLoading: _sending,
              onPress: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
