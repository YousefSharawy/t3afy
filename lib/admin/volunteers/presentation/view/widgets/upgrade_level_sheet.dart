import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/admin/volunteers/domain/entities/volunteer_details_entity.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_state.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/base/primary_widgets.dart';

class UpgradeLevelSheet extends StatefulWidget {
  const UpgradeLevelSheet({super.key, required this.details});

  final VolunteerDetailsEntity details;

  @override
  State<UpgradeLevelSheet> createState() => _UpgradeLevelSheetState();
}

class _UpgradeLevelSheetState extends State<UpgradeLevelSheet> {
  late final TextEditingController _levelCtrl;
  late final TextEditingController _titleCtrl;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _levelCtrl = TextEditingController(
      text: (widget.details.level + 1).toString(),
    );
    _titleCtrl = TextEditingController(text: widget.details.levelTitle);
  }

  @override
  void dispose() {
    _levelCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    HapticFeedback.mediumImpact();
    final level = int.tryParse(_levelCtrl.text.trim());
    final title = _titleCtrl.text.trim();
    if (level == null || title.isEmpty) return;

    setState(() => _sending = true);
    context.read<VolunteerDetailsCubit>().upgradeLevel(
      level: level,
      levelTitle: title,
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
                  'ترقية المستوى',
                  style: getSemiBoldStyle(
                    color: ColorManager.natural900,
                    fontSize: FontSize.s18,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                Text(
                  'المستوى الحالي: ${widget.details.level} - ${widget.details.levelTitle}',
                  style: getSemiBoldStyle(
                    color: ColorManager.natural400,
                    fontSize: FontSize.s14,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'المستوى الجديد',
                  controller: _levelCtrl,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: AppHeight.s12),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'لقب المستوى',
                  controller: _titleCtrl,
                ),
                SizedBox(height: AppHeight.s20),
                PrimaryElevatedButton(
                  title: _sending ? '' : 'ترقية',
                  titleWidget: _sending
                      ? SizedBox(
                          width: AppWidth.s20,
                          height: AppHeight.s20,
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
