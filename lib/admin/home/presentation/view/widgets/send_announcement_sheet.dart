import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';

import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/base/primary_widgets.dart';

class SendAnnouncementSheet extends StatefulWidget {
  const SendAnnouncementSheet({super.key});

  @override
  State<SendAnnouncementSheet> createState() => _SendAnnouncementSheetState();
}

class _SendAnnouncementSheetState extends State<SendAnnouncementSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _handleSend() {
    HapticFeedback.mediumImpact();
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      Toast.warning.show(context, title: 'الرجاء ملء جميع الحقول');
      return;
    }

    context.read<AdminHomeCubit>().sendAnnouncement(
      title: _titleController.text,
      body: _bodyController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminHomeCubit, AdminHomeState>(
      listenWhen: (prev, curr) => curr.maybeWhen(
        announcementSent: () => true,
        announcementError: (_) => true,
        orElse: () => false,
      ),
      listener: (context, state) {
        state.maybeWhen(
          announcementSent: () {
            Navigator.of(context).pop();
            Toast.success.show(context, title: 'تم إرسال الإعلان بنجاح');
            context.read<AdminHomeCubit>().loadDashboard();
          },
          announcementError: (message) {
            Toast.error.show(context, title: message);
          },
          orElse: () {},
        );
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.s20),
            ),
          ),
          padding: EdgeInsets.only(
            left: AppWidth.s18,
            right: AppWidth.s18,
            top: AppHeight.s20,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppHeight.s20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'إرسال إعلان للمتطوعين',
                style: getBoldStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s18,
                  color: ColorManager.natural900,
                ),
              ),
              SizedBox(height: AppHeight.s20),
              PrimaryTextFF(
                textAlign: .right,
                controller: _titleController,
                hint: 'عنوان الإعلان',
              ),
              SizedBox(height: AppHeight.s16),
              PrimaryTextFF(
                textAlign: .right,
                controller: _bodyController,
                hint: 'نص الرسالة',
                maxLines: 4,
              ),
              SizedBox(height: AppHeight.s24),
              BlocBuilder<AdminHomeCubit, AdminHomeState>(
                buildWhen: (prev, curr) => curr.maybeWhen(
                  announcementSending: () => true,
                  loaded: (_) => true,
                  orElse: () => false,
                ),
                builder: (context, state) {
                  final isSending = state.maybeWhen(
                    announcementSending: () => true,
                    orElse: () => false,
                  );

                  return Column(
                    children: [
                      PrimaryElevatedButton(
                        title: 'إرسال',
                        onPress: isSending ? () {} : _handleSend,
                        isLoading: isSending,
                        textStyle: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: AppHeight.s12),
                      PrimaryElevatedButton(
                        title: 'إلغاء',
                        onPress: () => Navigator.pop(context),
                        backGroundColor: ColorManager.natural200,
                        textStyle: getBoldStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontSize: FontSize.s16,
                          color: ColorManager.natural600,
                        ),
                      ),
                      SizedBox(height: AppHeight.s100),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
