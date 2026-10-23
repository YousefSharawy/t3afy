import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/tokens.dart';

import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';
import 'package:t3afy/app/resources/extenstions.dart';
import 'package:t3afy/base/primary_widgets.dart';

class SendAnnouncementSheet extends StatefulWidget {
  const SendAnnouncementSheet({super.key});

  @override
  State<SendAnnouncementSheet> createState() => _SendAnnouncementSheetState();
}

class _SendAnnouncementSheetState extends State<SendAnnouncementSheet> {
  final _formKey = GlobalKey<FormState>();
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

  static String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  void _handleSend() {
    HapticFeedback.mediumImpact();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AdminHomeCubit>().sendAnnouncement(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
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
          },
          announcementError: (message) {
            Toast.error.show(context, title: message);
          },
          orElse: () {},
        );
      },
      child: Padding(
        // Lifts the sheet above the keyboard.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Radii.sheet),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                Space.gutter,
                Space.vl,
                Space.gutter,
                Space.vl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ColorManager.line,
                          borderRadius: BorderRadius.circular(Radii.chip),
                        ),
                      ),
                    ),
                    SizedBox(height: Space.vl),
                    Text(
                      'إرسال إعلان للمتطوعين',
                      style: AppText.headline(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Space.vxl),
                    PrimaryTextFF(
                      controller: _titleController,
                      hint: 'عنوان الإعلان',
                      textInputAction: TextInputAction.next,
                      validator: (v) => _required(v, 'اكتب عنوان الإعلان'),
                    ),
                    SizedBox(height: Space.vl),
                    PrimaryTextFF(
                      controller: _bodyController,
                      hint: 'نص الرسالة',
                      maxLines: 4,
                      validator: (v) => _required(v, 'اكتب نص الرسالة'),
                    ),
                    SizedBox(height: Space.vxl),
                    BlocBuilder<AdminHomeCubit, AdminHomeState>(
                      buildWhen: (prev, curr) => curr.maybeWhen(
                        announcementSending: () => true,
                        announcementSent: () => true,
                        announcementError: (_) => true,
                        loaded: (_) => true,
                        orElse: () => false,
                      ),
                      builder: (context, state) {
                        final isSending = state.maybeWhen(
                          announcementSending: () => true,
                          orElse: () => false,
                        );
                        return PrimaryElevatedButton(
                          title: 'إرسال الإعلان',
                          icon: AppIcons.send,
                          onPress: _handleSend,
                          isLoading: isSending,
                        );
                      },
                    ),
                    SizedBox(height: Space.vs),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorManager.inkMuted,
                        minimumSize: Size.fromHeight(AppSizes.touch),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
