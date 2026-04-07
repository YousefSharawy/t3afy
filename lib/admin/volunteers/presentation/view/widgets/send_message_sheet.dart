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

class SendMessageSheet extends StatefulWidget {
  const SendMessageSheet({super.key});

  @override
  State<SendMessageSheet> createState() => _SendMessageSheetState();
}

class _SendMessageSheetState extends State<SendMessageSheet> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    HapticFeedback.mediumImpact();
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty || body.isEmpty) return;

    setState(() => _sending = true);
    final adminId = LocalAppStorage.getUserId() ?? '';
    context.read<VolunteerDetailsCubit>().sendDirectMessage(
      adminId: adminId,
      title: title,
      body: body,
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
                  'إرسال رسالة مباشرة',
                  style: getSemiBoldStyle(
                    color: ColorManager.natural900,
                    fontSize: FontSize.s18,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
                SizedBox(height: AppHeight.s16),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'عنوان الرسالة',
                  controller: _titleCtrl,
                ),
                SizedBox(height: AppHeight.s12),
                PrimaryTextFF(
                  textAlign: .right,
                  hint: 'نص الرسالة',
                  controller: _bodyCtrl,
                  maxLines: 4,
                ),
                SizedBox(height: AppHeight.s20),
                PrimaryElevatedButton(
                  title: _sending ? '' : 'إرسال',
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
