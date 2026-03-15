import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t3afy/app/resources/color_manager.dart';
import 'package:t3afy/app/resources/font_manager.dart';
import 'package:t3afy/app/resources/style_manager.dart';
import 'package:t3afy/app/resources/values_manager.dart';
import 'package:t3afy/admin/home/presentation/cubit/admin_home_cubit.dart';

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
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء ملء جميع الحقول')),
      );
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
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();
            messenger.showSnackBar(
              const SnackBar(content: Text('تم إرسال الإعلان بنجاح')),
            );
            context.read<AdminHomeCubit>().loadDashboard();
          },
          announcementError: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
          orElse: () {},
        );
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.blueOne900,
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
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppHeight.s20),
              TextField(
                controller: _titleController,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'عنوان الإعلان',
                  hintStyle: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: ColorManager.blueTwo200,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s16,
                    vertical: AppHeight.s12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    borderSide: BorderSide(color: ColorManager.blueOne700),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    borderSide: BorderSide(color: ColorManager.blueOne700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    borderSide: BorderSide(color: ColorManager.blueTwo500),
                  ),
                  filled: true,
                  fillColor: ColorManager.blueOne800,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: AppHeight.s16),
              TextField(
                controller: _bodyController,
                maxLines: 4,
                style: getRegularStyle(
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontSize.s14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'نص الرسالة',
                  hintStyle: getRegularStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: FontSize.s14,
                    color: ColorManager.blueTwo200,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppWidth.s16,
                    vertical: AppHeight.s12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    borderSide: BorderSide(color: ColorManager.blueOne700),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    borderSide: BorderSide(color: ColorManager.blueOne700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                    borderSide: BorderSide(color: ColorManager.blueTwo500),
                  ),
                  filled: true,
                  fillColor: ColorManager.blueOne800,
                ),
                textDirection: TextDirection.rtl,
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSending ? null : _handleSend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.blueTwo500,
                            disabledBackgroundColor:
                                ColorManager.blueTwo500.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s12),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: AppHeight.s12,
                            ),
                          ),
                          child: isSending
                              ? SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'إرسال للجميع',
                                  style: getBoldStyle(
                                    fontFamily: FontConstants.fontFamily,
                                    fontSize: FontSize.s14,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: AppHeight.s12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: ColorManager.blueOne700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.s12),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: AppHeight.s12,
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: getBoldStyle(
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s14,
                              color: ColorManager.blueTwo200,
                            ),
                          ),
                        ),
                      ),
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