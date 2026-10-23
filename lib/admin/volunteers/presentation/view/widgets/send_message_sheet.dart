import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3afy/admin/volunteers/presentation/cubit/volunteer_details_cubit.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/sheet_action_listener.dart';
import 'package:t3afy/admin/volunteers/presentation/view/widgets/volunteer_sheet_frame.dart';
import 'package:t3afy/app/local_storage.dart';
import 'package:t3afy/app/resources/app_icons.dart';
import 'package:t3afy/app/resources/tokens.dart';
import 'package:t3afy/base/primary_widgets.dart';

class SendMessageSheet extends StatefulWidget {
  const SendMessageSheet({super.key});

  @override
  State<SendMessageSheet> createState() => _SendMessageSheetState();
}

class _SendMessageSheetState extends State<SendMessageSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    context.read<VolunteerDetailsCubit>().sendDirectMessage(
      adminId: LocalAppStorage.getUserId() ?? '',
      title: _titleCtrl.text.trim(),
      body: _bodyCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetActionListener(
      onError: () => setState(() => _sending = false),
      child: VolunteerSheetFrame(
        title: 'إرسال رسالة مباشرة',
        icon: AppIcons.message,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryTextFF(
                label: 'عنوان الرسالة',
                hint: 'مثال: تذكير بموعد المهمة',
                controller: _titleCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'اكتب عنوان الرسالة'
                    : null,
              ),
              SizedBox(height: Space.vm),
              PrimaryTextFF(
                label: 'نص الرسالة',
                hint: 'اكتب رسالتك هنا',
                controller: _bodyCtrl,
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'اكتب نص الرسالة'
                    : null,
              ),
              SizedBox(height: Space.vxl),
              PrimaryElevatedButton(
                title: 'إرسال',
                icon: AppIcons.send,
                isLoading: _sending,
                onPress: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
